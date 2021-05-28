import WebKit
import Combine

extension Web {
    final class Handler: NSObject, WKScriptMessageHandler {
        weak var web: Web?
        
        func userContentController(_: WKUserContentController, didReceive: WKScriptMessage) {
//            switch didReceive.body as? String {
//            case "getCurrentPosition":
//                var sub: AnyCancellable?
//                sub = (NSApp as! App).location.sink { [weak self] in
//                    $0.map {
//                        sub?.cancel()
//                        self?.web?.evaluateJavaScript(
//                            "locationReceived(\($0.coordinate.latitude), \($0.coordinate.longitude), \($0.horizontalAccuracy));")
//                    }
//                }
//                (NSApp as! App).geolocation()
//            default: break
//            }
        }
    }
}
