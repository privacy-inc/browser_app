import Foundation
import WatchConnectivity
import Combine
import Sleuth

final class Watch: NSObject, WCSessionDelegate {
    let forget = PassthroughSubject<Void, Never>()
    var sub: AnyCancellable?

    func activate(_ update: PassthroughSubject<Void, Never>) {
        if WCSession.isSupported() && WCSession.default.activationState != .activated {
            WCSession.default.delegate = self
            WCSession.default.activate()
            
            sub = update.sink {
                if WCSession.isSupported() && WCSession.default.activationState == .activated && WCSession.default.isPaired && WCSession.default.isWatchAppInstalled {
                    try? WCSession.default.updateApplicationContext(
                        [Share.Key.chart.rawValue : Share.chart,
                         Share.Key.blocked.rawValue : Share.blocked])
                }
            }
        }
    }
    
    func session(_: WCSession, didReceiveMessage: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
            didReceiveMessage[Share.Key.forget.rawValue].flatMap { $0 as? Bool }.map {
                guard $0 else { return }
                self?.forget.send()
            }
        }
    }
    
    func session(_: WCSession, activationDidCompleteWith: WCSessionActivationState, error: Error?) { }
    func sessionDidBecomeInactive(_: WCSession) { }
    func sessionDidDeactivate(_: WCSession) { }
}
