import AppKit
import Combine

extension Info {
    final class Froob: Info {
        private var subscription: AnyCancellable?
        
        init() {
            let accept = Option(title: "Accept")
            super.init(title: "Privacy Plus", message: Purchases.froob, option: accept)
            
            subscription = accept
                .click
                .sink { [weak self] in
                    NSApp.store()
                    self?.close()
                    
                }
        }
    }
}
