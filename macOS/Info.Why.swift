import AppKit
import Combine

extension Info {
    final class Why: Info {
        private var subscription: AnyCancellable?
        
        init() {
            super.init(title: "Why purchasing Privacy Plus?", message: Purchases.why)
        }
    }
}
