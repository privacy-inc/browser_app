import WatchKit
import Combine
import Sleuth

extension App {
    final class Delegate: NSObject, WKExtensionDelegate {
        private var fetch: AnyCancellable?
        
        func applicationDidFinishLaunching() {
            WKExtension.shared().registerForRemoteNotifications()
        }
        
        func applicationDidBecomeActive() {
            Synch.cloud.pull.send()
        }
        
        func didReceiveRemoteNotification(_: [AnyHashable : Any], fetchCompletionHandler: @escaping (WKBackgroundFetchResult) -> Void) {
            fetch = Synch
                    .cloud
                    .receipt
                    .sink {
                        fetchCompletionHandler($0 ? .newData : .noData)
                    }
        }
    }
}
