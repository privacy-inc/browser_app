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
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsInlineMediaPlayback = true
        configuration.ignoresViewportScaleLimits = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = Defaults.popups && Defaults.javascript
        configuration.preferences.isFraudulentWebsiteWarningEnabled = secure
        configuration.websiteDataStore = .nonPersistent()

        if Defaults.ads {
            configuration.userContentController.blockAds()
        }
        
        if Defaults.cookies {
            configuration.userContentController.blockCookies()
        }
        
        super.init(frame: .zero, configuration: configuration)
        navigationDelegate = self
        uiDelegate = self
        allowsBackForwardNavigationGestures = true
    }
    
    final func webView(_: WKWebView, didReceive: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard secure else {
            completionHandler(.useCredential, didReceive.protectionSpace.serverTrust.map(URLCredential.init(trust:)))
            return
        }
        completionHandler(.performDefaultHandling, nil)
    }
    
    deinit {
        uiDelegate = nil
        navigationDelegate = nil
    }
}
