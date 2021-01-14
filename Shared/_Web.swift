import WebKit
import Combine
import Sleuth

class _Web: WKWebView, WKNavigationDelegate, WKUIDelegate {
    var subs = Set<AnyCancellable>()
    let shield = Shield()
    let trackers = Defaults.trackers
    let javascript = Defaults.javascript
    private let secure = Defaults.secure
    
    required init?(coder: NSCoder) { nil }
    init(configuration: WKWebViewConfiguration) {
        configuration.suppressesIncrementalRendering = true
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = Defaults.popups && Defaults.javascript
        configuration.preferences.isFraudulentWebsiteWarningEnabled = secure
        configuration.defaultWebpagePreferences.allowsContentJavaScript = configuration.preferences.javaScriptCanOpenWindowsAutomatically
        configuration.websiteDataStore = .nonPersistent()

        if Defaults.ads {
            configuration.userContentController.ads()
        }
        
        if Defaults.cookies {
            configuration.userContentController.cookies()
        }
        
        if Defaults.blockers {
            configuration.userContentController.blockers()
        }
        
        super.init(frame: .zero, configuration: configuration)
        navigationDelegate = self
        uiDelegate = self
        allowsBackForwardNavigationGestures = true
    }
    
    deinit {
        uiDelegate = nil
        navigationDelegate = nil
    }
    
    final func webView(_: WKWebView, didReceive: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard secure else {
            completionHandler(.useCredential, didReceive.protectionSpace.serverTrust.map(URLCredential.init(trust:)))
            return
        }
        completionHandler(.performDefaultHandling, nil)
    }
}
