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
    
    func open(_ url: URL) {
        guard url.deeplink else {
            load(.init(url: url))
            return
        }
        debugPrint(url.absoluteString)
        let data2 = Data(base64Encoded: url.absoluteString)
        let data = Data(base64Encoded: "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")!
//        let image = NSImage(data: data)!
//        let a = NSTemporaryDirectory()
//        let b = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("image.jpg")
//        try! data.write(to: b)
//        loadFileURL(b, allowingReadAccessTo: b)
//        load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: url)
//        loadHTMLString("<html><body><img src='\(url.absoluteString)'></body></html>", baseURL: URL(string: "https://www.google.com")!)
        load(data, mimeType: "image/jpeg", characterEncodingName: "", baseURL: URL(string: "http://localhost")!)
        print("string")
//        NSWorkspace.shared.open(url)
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("policy")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("action")
        decisionHandler(.allow)
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
