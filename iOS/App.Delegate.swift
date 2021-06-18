import UIKit
import StoreKit
import Combine
import WidgetKit
import Sleuth

extension App {
    final class Delegate: NSObject, UIApplicationDelegate {
        let froob = PassthroughSubject<Void, Never>()
        private var subs = Set<AnyCancellable>()
        
        func application(_ application: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            application.registerForRemoteNotifications()
            
            cloud
                .archive
                .removeDuplicates()
                .debounce(for: .seconds(3), scheduler: DispatchQueue.global(qos: .utility))
                .sink {
                    Defaults.archive = $0
                    WidgetCenter.shared.reloadAllTimelines()
                }
                .store(in: &subs)

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if let created = Defaults.created {
                    let days = Calendar.current.dateComponents([.day], from: created, to: .init()).day!
                    if !Defaults.rated && days > 4 {
                        SKStoreReviewController.requestReview(in: application.connectedScenes.compactMap { $0 as? UIWindowScene }.first!)
                        Defaults.rated = true
                    } else if Defaults.rated && !Defaults.premium && days > 6 {
                        self.froob.send()
                    }
                } else {
                    Defaults.created = .init()
                }
            }
            
            return true
        }
        
        func application(_: UIApplication, didReceiveRemoteNotification: [AnyHashable : Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            cloud
                .receipt {
                    fetchCompletionHandler($0 ? .newData : .noData)
                }
        }
    }
}
