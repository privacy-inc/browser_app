import WatchKit
import Combine
import Archivable

extension App {
    final class Delegate: NSObject, WKExtensionDelegate {
        private var fetch: AnyCancellable?
        
        func applicationDidFinishLaunching() {
            WKExtension.shared().registerForRemoteNotifications()
        }
        
        func applicationDidBecomeActive() {
            Cloud.shared.pull.send()
        }
        
        func didReceiveRemoteNotification(_: [AnyHashable : Any], fetchCompletionHandler: @escaping (WKBackgroundFetchResult) -> Void) {
            Cloud.shared.receipt {
                fetchCompletionHandler($0 ? .newData : .noData)
            }
        }
    }
}
