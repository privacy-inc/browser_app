import WebKit
import Combine
import CoreLocation
import Sleuth

final class Web: _Web, WKScriptMessageHandler, CLLocationManagerDelegate {
    private weak var browser: Browser!
    private var destination = Destination.window
    private let manager = CLLocationManager()
    
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        self.browser = browser
        
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Mozilla/5 Version/14 Safari/605"
        configuration.defaultWebpagePreferences.preferredContentMode = .desktop
        configuration.userContentController.addUserScript(.init(source: """
var listeners = [];

function locationReceived(latitude, longitude, accuracy) {
    var position = {
        coords: {
            latitude: latitude,
            longitude: longitude,
            accuracy: accuracy
        }
    };

    for (var i in listeners) {
        listeners[i](position);
    }

    listeners = [];
}

navigator.geolocation.getCurrentPosition = function(success, error, options) {
    listeners[0] = success;
    window.webkit.messageHandlers.handler.postMessage('');
};

navigator.geolocation.watchPosition = function(success, error, options) {
    listeners[0] = success;
    window.webkit.messageHandlers.handler.postMessage('');
};

navigator.geolocation.clearWatch = function(id) {
    listeners[0] = success;
    window.webkit.messageHandlers.handler.postMessage('');
};

""", injectionTime: .atDocumentEnd, forMainFrameOnly: false))
        
        if NSApp.windows.first!.effectiveAppearance == NSAppearance(named: .darkAqua) && Defaults.dark {
            configuration.userContentController.dark()
        }
        
        super.init(configuration: configuration)
        translatesAutoresizingMaskIntoConstraints = false
        setValue(false, forKey: "drawsBackground")
        self.configuration.userContentController.add(self, name: "handler")
        manager.delegate = self
        
        publisher(for: \.estimatedProgress).sink {
            browser.progress.value = $0
        }.store(in: &subs)
        
        publisher(for: \.isLoading).sink {
            browser.loading.value = $0
        }.store(in: &subs)
        
        publisher(for: \.title).sink {
            $0.map {
                guard !$0.isEmpty else { return }
                browser.page.value?.title = $0
            }
        }.store(in: &subs)
        
        publisher(for: \.url).sink {
            $0.map {
                browser.page.value?.url = $0
            }
        }.store(in: &subs)
        
        publisher(for: \.canGoBack).sink {
            browser.backwards.value = $0
        }.store(in: &subs)
        
        publisher(for: \.canGoForward).sink {
            browser.forwards.value = $0
        }.store(in: &subs)
        
        browser.previous.sink { [weak self] in
            self?.goBack()
        }.store(in: &subs)
        
        browser.next.sink { [weak self] in
            self?.goForward()
        }.store(in: &subs)
        
        browser.reload.sink { [weak self] in
            self?.reload()
        }.store(in: &subs)
        
        browser.stop.sink { [weak self] in
            self?.stopLoading()
        }.store(in: &subs)
    }
    
    func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
        browser.error.value = nil
    }
    
    func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
        if let error = withError as? URLError {
            switch error.code {
            case .networkConnectionLost,
                 .notConnectedToInternet,
                 .dnsLookupFailed,
                 .resourceUnavailable,
                 .unsupportedURL,
                 .cannotFindHost,
                 .cannotConnectToHost,
                 .timedOut,
                 .secureConnectionFailed,
                 .serverCertificateUntrusted:
                browser.error.value = error.localizedDescription
            default: break
            }
        } else if (withError as NSError).code == 101 {
            browser.error.value = withError.localizedDescription
        }
    }
    
    func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if action.targetFrame == nil && action.navigationType == .other {
            action.request.url.map { url in
                switch destination {
                case .window:
                    (NSApp as? App)?.window(url)
                case .tab:
                    (window as? Window)?.newTab(url)
                case .download:
                    URLSession.shared.dataTaskPublisher(for: url)
                        .map(\.data)
                        .receive(on: DispatchQueue.main)
                        .replaceError(with: .init())
                        .sink { [weak self] in
                            (self?.window as? Window)?.save(url.lastPathComponent, data: $0)
                        }.store(in: &subs)
                    break
                }
                destination = .window
            }
        } else if action.navigationType == .linkActivated {
            (window as? Window)?.newTab(url)
        }
        return nil
    }
    
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        var sub: AnyCancellable?
        sub = shield.policy(for: decidePolicyFor.request.url!, shield: trackers).receive(on: DispatchQueue.main).sink { [weak self] in
            sub?.cancel()
            switch $0 {
            case .allow:
                print("allow \(decidePolicyFor.request.url!)")
                preferences.allowsContentJavaScript = self?.javascript ?? false
                decisionHandler(.allow, preferences)
            case .external:
                print("external \(decidePolicyFor.request.url!)")
                decisionHandler(.cancel, preferences)
                NSWorkspace.shared.open(decidePolicyFor.request.url!)
            case .ignore:
                decisionHandler(.cancel, preferences)
            case .block(let domain):
                decisionHandler(.cancel, preferences)
                Share.blocked.append(domain)
                (NSApp as! App).blocked.send()
            }
        }
    }
    
    func userContentController(_: WKUserContentController, didReceive: WKScriptMessage) {
        manager.requestLocation()
    }
    
    func locationManager(_: CLLocationManager, didUpdateLocations: [CLLocation]) {
        didUpdateLocations.first.map {
            evaluateJavaScript("locationReceived(\($0.coordinate.latitude), \($0.coordinate.longitude), \($0.horizontalAccuracy));");
        }
    }
    
    func locationManager(_: CLLocationManager, didFailWithError: Error) { }
    
    override func willOpenMenu(_ menu: NSMenu, with: NSEvent) {
        menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierOpenLinkInNewWindow" }.map { item in
            let newTab = NSMenuItem(title: NSLocalizedString("Open Link in New Tab", comment: ""), action: #selector(tabbed), keyEquivalent: "")
            newTab.target = self
            newTab.representedObject = item
            menu.items = [newTab, .separator()] + menu.items
            
            menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierDownloadLinkedFile" }.map {
                $0.target = self
                $0.action = #selector(download)
                $0.representedObject = item
            }
        }
        menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierOpenImageInNewWindow" }.map { item in
            let newTab = NSMenuItem(title: NSLocalizedString("Open Image in New Tab", comment: ""), action: #selector(tabbed), keyEquivalent: "")
            newTab.target = self
            newTab.representedObject = item
            menu.insertItem(newTab, at: menu.items.firstIndex(of: item)!)
            
            menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierDownloadImage" }.map {
                $0.target = self
                $0.action = #selector(download)
                $0.representedObject = item
            }
        }
    }
    
    @objc private func tabbed(_ item: NSMenuItem) {
        destination = .tab
        item.synth()
    }
    
    @objc private func download(_ item: NSMenuItem) {
        destination = .download
        item.synth()
    }
}
