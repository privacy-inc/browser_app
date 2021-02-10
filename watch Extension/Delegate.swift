import Foundation
import WatchConnectivity
import Sleuth

final class Delegate: NSObject, ObservableObject, WCSessionDelegate {
    @Published private(set) var chart = Share.chart
    @Published private(set) var blocked = Share.blocked
    
    func session(_: WCSession, activationDidCompleteWith: WCSessionActivationState, error: Error?) { }

    func session(_: WCSession, didReceiveApplicationContext: [String: Any]) {
        Share.chart = didReceiveApplicationContext[Share.Key.chart.rawValue] as? [Date] ?? []
        Share.blocked = didReceiveApplicationContext[Share.Key.blocked.rawValue] as? [String] ?? []
        DispatchQueue.main.async { [weak self] in
            self?.refresh()
        }
    }
    
    func refresh() {
        chart = Share.chart
        blocked = Share.blocked
    }
    
    func forget() {
        Share.chart = []
        Share.blocked = []
        refresh()
        guard WCSession.isSupported() && WCSession.default.activationState == .activated && WCSession.default.isReachable && WCSession.default.isCompanionAppInstalled else { return }
        WCSession.default.sendMessage([Share.Key.forget.rawValue : true], replyHandler: nil, errorHandler: nil)
    }
}
