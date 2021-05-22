import WebKit
import Sleuth

class Webview: WKWebView, WKNavigationDelegate, WKUIDelegate {
    let settings: Sleuth.Settings
    
    required init?(coder: NSCoder) { nil }
    init(configuration: WKWebViewConfiguration, settings: Sleuth.Settings) {
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
    
    final func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
}
