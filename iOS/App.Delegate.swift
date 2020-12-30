import UIKit
import StoreKit

extension App {
    final class Delegate: NSObject, UIApplicationDelegate {
        func rate() {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                if let created = User.created {
//                    if !User.rated && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 4 {
//                        User.rated = true
//                        SKStoreReviewController.requestReview(in: UIApplication.shared.windows.first!.windowScene!)
//                    }
//                } else {
//                    User.created = .init()
//                }
//            }
        }
        
        func application(_: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "AccentColor")!
            return true
        }
    }
}
