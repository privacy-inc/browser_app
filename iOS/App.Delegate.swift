import UIKit
import Combine
import WidgetKit
import StoreKit
import Sleuth

extension App {
    final class Delegate: NSObject, UIApplicationDelegate {
        let froob = PassthroughSubject<Void, Never>()
        private var fetch: AnyCancellable?
        private var subs = Set<AnyCancellable>()
        
        func rate() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let created = Defaults.created {
                    if !Defaults.rated && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 4 {
                        Defaults.rated = true
                        SKStoreReviewController.requestReview(in: UIApplication.shared.windows.first!.windowScene!)
                    }
                } else {
                    Defaults.created = .init()
                }
            }
        }
        
        func application(_ application: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            application.registerForRemoteNotifications()
            
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "AccentColor")!
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(white: 0.7, alpha: 1)], for: .normal)
            
            if !Defaults.premium {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    if let created = Defaults.created {
                        if Defaults.rated && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 6 {
                            self?.froob.send()
                        }
                    }
                }
            }
            
            Synch
                .cloud
                .archive
                .merge(with: Synch.cloud.save)
                .removeDuplicates()
                .debounce(for: .seconds(2), scheduler: DispatchQueue.global(qos: .utility))
                .sink {
                    Defaults.archive = $0
                    WidgetCenter.shared.reloadAllTimelines()
                }
                .store(in: &subs)
            
            return true
        }
        
        func application(_: UIApplication, didReceiveRemoteNotification: [AnyHashable : Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            fetch = Synch
                    .cloud
                    .receipt
                    .sink {
                        fetchCompletionHandler($0 ? .newData : .noData)
                    }
        }
    }
}
