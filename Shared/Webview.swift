import WebKit
import Combine
import Sleuth

class Webview: WKWebView, WKNavigationDelegate, WKUIDelegate {
    var subs = Set<AnyCancellable>()
    let id: UUID
    let browse: Int
    let settings: Sleuth.Settings
    
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
        
        WKContentRuleListStore.default()!.compileContentRuleList(forIdentifier: "rules", encodedContentRuleList: settings.rules) { rules, _ in
            rules.map(configuration.userContentController.add)
        }
        
        super.init(frame: .zero, configuration: configuration)
        navigationDelegate = self
        uiDelegate = self
        allowsBackForwardNavigationGestures = true
    }
    
    deinit {
        uiDelegate = nil
        navigationDelegate = nil
        scrollView.delegate = nil
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
            tab.error(id, .init(url: $0.absoluteString, description: $1))
        } ((withError as? URLError)
            .flatMap(\.failingURL)
            ?? url ?? URL(string: "about:blank")!, withError.localizedDescription)
        cloud.activity()
    }
}
