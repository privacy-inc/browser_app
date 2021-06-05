import AppKit
import Combine

extension Info {
    final class Alternatives: Info {
        private var subscription: AnyCancellable?
        
        init() {
            super.init(title: "Alternatives to purchasing", message: Purchases.alternatives)
        }
    }
}
