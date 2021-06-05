import AppKit
import Combine

extension Info {
    final class Froob: Info {
        private var subscription: AnyCancellable?
        
        init() {
            super.init(title: "Support Privacy", message: Purchases.froob)
            animationBehavior = .alertPanel
            
            let accept = Control.Capsule(title: "Accept")
            let view = NSView()
            view.addSubview(accept)
            
            accept.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            accept.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
            
            let bar = NSTitlebarAccessoryViewController()
            bar.view = view
            bar.layoutAttribute = .top
            addTitlebarAccessoryViewController(bar)
            
            subscription = accept
                .click
                .sink { [weak self] in
                    NSApp.store()
                    self?.close()
                }
        }
    }
}
