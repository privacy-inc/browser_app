import Foundation
import WatchConnectivity
import Sleuth

final class Delegate: NSObject, ObservableObject, WCSessionDelegate {
    @Published var chart = Share.chart
    
    func session(_: WCSession, activationDidCompleteWith: WCSessionActivationState, error: Error?) { }

    func session(_: WCSession, didReceiveApplicationContext: [String: Any]) {
        Share.chart = didReceiveApplicationContext[Share.Key.chart.rawValue] as? [Date] ?? []
        DispatchQueue.main.async { [weak self] in
            self?.chart = Share.chart
        }
    }
    
    func forget() {
        guard WCSession.isSupported() && WCSession.default.activationState == .activated && WCSession.default.isReachable && WCSession.default.isCompanionAppInstalled else { return }
        WCSession.default.sendMessage([Share.Key.forget.rawValue : true], replyHandler: nil, errorHandler: nil)
        Share.chart = []
        chart = Share.chart
    }
}
