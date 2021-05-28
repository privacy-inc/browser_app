import WatchKit

extension App {
    final class Delegate: NSObject, WKExtensionDelegate {
        func applicationDidFinishLaunching() {
            WKExtension.shared().registerForRemoteNotifications()
        }
        
        func applicationDidBecomeActive() {
            cloud.pull.send()
        }
        
        func didReceiveRemoteNotification(_: [AnyHashable : Any], fetchCompletionHandler: @escaping (WKBackgroundFetchResult) -> Void) {
            cloud
                .receipt {
                    fetchCompletionHandler($0 ? .newData : .noData)
                }
        }
    }
}
