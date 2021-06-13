import WebKit
import Combine
import Sleuth

class Webview: WKWebView, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    final var subs = Set<AnyCancellable>()
    final let id: UUID
    final let browse: Int
    final let settings: Sleuth.Settings
    
    required init?(coder: NSCoder) { nil }
    init(configuration: WKWebViewConfiguration, id: UUID, browse: Int, settings: Sleuth.Settings) {
        self.id = id
        self.browse = browse
        self.settings = settings
        configuration.suppressesIncrementalRendering = false
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = settings.popups && settings.javascript
        configuration.preferences.isFraudulentWebsiteWarningEnabled = !settings.http
        configuration.defaultWebpagePreferences.allowsContentJavaScript = settings.popups && settings.javascript
        configuration.websiteDataStore = .nonPersistent()
        configuration.userContentController.addUserScript(.init(source: settings.start, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        configuration.userContentController.addUserScript(.init(source: settings.end, injectionTime: .atDocumentEnd, forMainFrameOnly: true))

        WKContentRuleListStore
            .default()!
            .compileContentRuleList(forIdentifier: "rules", encodedContentRuleList: settings.rules) { rules, _ in
                rules.map(configuration.userContentController.add)
            }
        
        super.init(frame: .zero, configuration: configuration)
        navigationDelegate = self
        uiDelegate = self
        allowsBackForwardNavigationGestures = true
        self.configuration.userContentController.add(self, name: "handler")
        
        publisher(for: \.estimatedProgress, options: .new)
            .removeDuplicates()
            .sink {
                tabber.update(id, progress: $0)
            }
            .store(in: &subs)

        publisher(for: \.isLoading, options: .new)
            .removeDuplicates()
            .sink {
                tabber.update(id, loading: $0)
            }
            .store(in: &subs)

        publisher(for: \.canGoForward, options: .new)
            .removeDuplicates()
            .sink {
                tabber.update(id, forward: $0)
            }
            .store(in: &subs)

        publisher(for: \.canGoBack, options: .new)
            .removeDuplicates()
            .sink {
                tabber.update(id, back: $0)
            }
            .store(in: &subs)
        
        publisher(for: \.title, options: .new)
            .compactMap {
                $0
            }
            .filter {
                !$0.isEmpty
            }
            .removeDuplicates()
            .sink {
                cloud.update(browse, title: $0)
            }
            .store(in: &subs)

        publisher(for: \.url, options: .new)
            .compactMap {
                $0
            }
            .removeDuplicates()
            .sink {
                cloud.update(browse, url: $0)
            }
            .store(in: &subs)
        
        load(cloud.archive.value.page(browse).access)
    }
    
    deinit {
        uiDelegate = nil
        navigationDelegate = nil
    }
    
    func external(_ url: URL) {
        
    }
    
    func userContentController(_: WKUserContentController, didReceive: WKScriptMessage) {

    }
    
    final func load(_ access: Page.Access) {
        switch access {
        case .remote:
            _ = access
                .url
                .map(load)
        case .local:
            if let url = access.url, let directory = access.directory {
                loadFileURL(url, allowingReadAccessTo: directory)
            }
        }
    }
    
    final func load(_ url: URL) {
        load(.init(url: url))
    }
    
    final func webView(_: WKWebView, didReceive: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard settings.http else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        completionHandler(.useCredential, didReceive.protectionSpace.serverTrust.map(URLCredential.init(trust:)))
    }
    
    final func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
        {
            cloud.update(browse, url: $0)
            cloud.update(browse, title: $1)
            tabber.error(id, .init(url: $0.absoluteString, description: $1))
        } ((withError as? URLError)
            .flatMap(\.failingURL)
            ?? url
            ?? {
                $0?["NSErrorFailingURLKey"] as? URL
            } (withError._userInfo as? [String : Any])
            ?? URL(string: "about:blank")!, withError.localizedDescription)
        cloud.activity()
        tabber.update(id, progress: 1)
    }
    
    final func webView(_: WKWebView, didFinish: WKNavigation!) {
        tabber.update(id, progress: 1)
        cloud.activity()
    }
    
    final func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        switch cloud.policy(decidePolicyFor.request.url!) {
        case .allow:
            print("allow \(decidePolicyFor.request.url!)")
            preferences.allowsContentJavaScript = settings.javascript
            decisionHandler(.allow, preferences)
        case .external:
            print("external \(decidePolicyFor.request.url!)")
            decisionHandler(.cancel, preferences)
            external(decidePolicyFor.request.url!)
        case .ignore:
            decisionHandler(.cancel, preferences)
        case .block:
            decisionHandler(.cancel, preferences)
            decidePolicyFor
                .targetFrame
                .map(\.isMainFrame)
                .map {
                    guard $0 else { return }
                    tabber.error(id, .init(url: decidePolicyFor.request.url!.absoluteString, description: "Blocked"))
                }
        }
    }
    
    final class func clear() {
        URLCache.shared.removeAllCachedResponses()
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        [WKWebsiteDataStore.default(), WKWebsiteDataStore.nonPersistent()].forEach {
            $0.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {
                $0.forEach {
                    WKWebsiteDataStore.default().removeData(ofTypes: $0.dataTypes, for: [$0]) { }
                }
            }
            $0.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast) { }
        }
    }
}
