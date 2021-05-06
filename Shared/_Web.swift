import WebKit
import Combine
import Archivable
import Sleuth

class _Web: WKWebView, WKNavigationDelegate, WKUIDelegate {
    var id: Int?
    var subs = Set<AnyCancellable>()
    let javascript = Defaults.javascript
    let router = Defaults.trackers ? Router.secure : .regular
    private let secure = Defaults.secure
    
#if os(macOS)
    private let rem = 1.1
#endif
#if os(iOS)
    private let rem = 2.5
#endif
    
    required init?(coder: NSCoder) { nil }
    init(configuration: WKWebViewConfiguration) {
        configuration.suppressesIncrementalRendering = false
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
        
        if secure {
            configuration.userContentController.secure()
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
    
    final func load(_ id: Int) {
        self.id = id
        _ = Cloud
            .shared
            .entry(id)
            .flatMap(\.access)
            .map {
                .init(url: $0)
            }
            .map(load)
    }
    
    final func webView(_: WKWebView, didReceive: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard secure else {
            completionHandler(.useCredential, didReceive.protectionSpace.serverTrust.map(URLCredential.init(trust:)))
            return
        }
        completionHandler(.performDefaultHandling, nil)
    }
    
    final func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
        load(.init(url: URL(string: "data:text/html," + """
<html>\
    <head>\
        <title>\
            \(withError.localizedDescription)\
        </title>\
    </head>\
    <body style='margin: 100px 30px; font-size: \(rem)rem; font-family: -apple-system; text-align: center;'>\
        \((withError as? URLError)?.failingURL.map {
            """
        <a href="\($0)">\
            \($0)\
        </a>
"""
        } ?? "")
        <div>\
            \(withError.localizedDescription)\
        </div>\
    </body>\
</html>
""".replacingOccurrences(of: "’", with: "'")
                                .addingPercentEncoding(withAllowedCharacters: [])!)!))
    }
}
