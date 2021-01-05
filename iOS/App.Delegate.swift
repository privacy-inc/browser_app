import UIKit
import StoreKit
import Sleuth

extension App {
    final class Delegate: NSObject, UIApplicationDelegate {
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
        
        func application(_: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "AccentColor")!
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(white: 0.7, alpha: 1)], for: .normal)
            return true
        }
    }
}
