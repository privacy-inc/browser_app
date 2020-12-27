import WebKit
import Combine
import Sleuth

final class Web: WKWebView, WKNavigationDelegate, WKUIDelegate {
    private weak var browser: Browser!
    private var inTab = false
    private var subs = Set<AnyCancellable>()
    private let shield = Shield()
    private let secure = Defaults.secure
    private let trackers = Defaults.trackers
    private let javascript = Defaults.javascript
    
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        self.browser = browser
        
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Safari/605"
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.defaultWebpagePreferences.preferredContentMode = .desktop
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = Defaults.popups && Defaults.javascript
        configuration.preferences.isFraudulentWebsiteWarningEnabled = secure
        configuration.websiteDataStore = .nonPersistent()
        
        if NSApp.windows.first!.effectiveAppearance == NSAppearance(named: .darkAqua) && Defaults.dark {
            configuration.userContentController.dark()
        }
        
        if Defaults.ads {
            configuration.userContentController.blockAds()
        }
        
        if Defaults.cookies {
            configuration.userContentController.blockCookies()
        }
        
        super.init(frame: .zero, configuration: configuration)
        translatesAutoresizingMaskIntoConstraints = false
        navigationDelegate = self
        uiDelegate = self
        allowsBackForwardNavigationGestures = true
        setValue(false, forKey: "drawsBackground")
        
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
        
        publisher(for: \.isLoading).sink {
            browser.loading.value = $0
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
    
    deinit {
        uiDelegate = nil
        navigationDelegate = nil
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
    
    func webView(_: WKWebView, didReceive: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard secure else {
            completionHandler(.useCredential, didReceive.protectionSpace.serverTrust.map(URLCredential.init(trust:)))
            return
        }
        completionHandler(.performDefaultHandling, nil)
    }
    
    func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if action.targetFrame == nil && (action.navigationType == .other || action.navigationType == .linkActivated) {
            action.request.url.map {
                if inTab {
                    inTab = false
                    (window as? Window)?.newTab($0)
                } else {
                    (NSApp as? App)?.newWindowWith($0)
                }
            }
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
                decisionHandler(.allow, preferences)
            case .block(let domain):
                decisionHandler(.cancel, preferences)
                (NSApp as! App).blocked.value.insert(domain)
            }
        }
    }
    
    override func willOpenMenu(_ menu: NSMenu, with: NSEvent) {
        menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierOpenLinkInNewWindow" }.map {
            let newTab = NSMenuItem(title: NSLocalizedString("Open Link in New Tab", comment: ""), action: #selector(openInTab), keyEquivalent: "")
            newTab.target = self
            newTab.representedObject = $0
            menu.items = [newTab, .separator()] + menu.items
        }
        menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierOpenImageInNewWindow" }.map {
            let newTab = NSMenuItem(title: NSLocalizedString("Open Image in New Tab", comment: ""), action: #selector(openInTab), keyEquivalent: "")
            newTab.target = self
            newTab.representedObject = $0
            menu.insertItem(newTab, at: menu.items.firstIndex(of: $0)!)
        }
    }
    
    @objc private func openInTab(_ item: NSMenuItem) {
        inTab = true
        (item.representedObject as? NSMenuItem).map {
            guard let action = $0.action else { return }
            NSApp.sendAction(action, to: $0.target, from: $0)
        }
    }
}
