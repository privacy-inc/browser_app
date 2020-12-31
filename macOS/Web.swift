import WebKit
import Sleuth

final class Web: _Web {
    private var destination = Destination.window
    
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Safari/605"
        configuration.defaultWebpagePreferences.preferredContentMode = .desktop
        
        if NSApp.windows.first!.effectiveAppearance == NSAppearance(named: .darkAqua) && Defaults.dark {
            configuration.userContentController.dark()
        }
        
        super.init(browser: browser, configuration: configuration)
        translatesAutoresizingMaskIntoConstraints = false
        setValue(false, forKey: "drawsBackground")
        
        
        
        publisher(for: \.estimatedProgress).sink {
            browser.progress($0)
        }.store(in: &subs)
        
        publisher(for: \.isLoading).sink {
            browser.loading($0)
        }.store(in: &subs)
        
        publisher(for: \.title).sink {
            $0.map {
                guard !$0.isEmpty else { return }
                browser.title($0)
            }
        }.store(in: &subs)
        
        publisher(for: \.url).sink {
            $0.map {
                browser.url($0)
            }
        }.store(in: &subs)
        
        publisher(for: \.canGoBack).sink {
            browser.backwards($0)
        }.store(in: &subs)
        
        publisher(for: \.canGoForward).sink {
            browser.forwards($0)
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
    
    
    
    final func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
        browser.error(nil)
    }
    
    final func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
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
                browser.error(error.localizedDescription)
            default: break
            }
        } else if (withError as NSError).code == 101 {
            browser.error(withError.localizedDescription)
        }
    }
    
    final func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if action.targetFrame == nil && (action.navigationType == .other || action.navigationType == .linkActivated) {
            action.request.url.map(browser.popup)
        }
        return nil
    }
    
    final func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
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
                self?.browser.external(decidePolicyFor.request.url!)
            case .ignore:
                decisionHandler(.allow, preferences)
            case .block(let domain):
                decisionHandler(.cancel, preferences)
                self?.browser.blocked(domain)
            }
        }
    }
    
    
    
    
    
    
    override func popup(_ url: URL) {
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
    
    override func external(_ url: URL) {
        NSWorkspace.shared.open(url)
    }
    
    override func blocked(_ domain: String) {
        (NSApp as! App).blocked.value.insert(domain)
    }
    
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
