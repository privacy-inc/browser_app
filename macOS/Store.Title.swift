import AppKit
import Combine

extension Store {
    final class Title: NSView {
        private var subscription: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            let restore = Control.Title(title: "Restore purchases")
            subscription = restore
                .click
                .sink {
                    
                }
            addSubview(restore)
            
            restore.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            restore.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        }
    }
}
