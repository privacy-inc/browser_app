import AppKit
import Combine

extension Settings {
    final class Title: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            let restore = Option(title: "Privacy Plus", image: "plus")
            restore
                .click
                .sink {
                    NSApp.store()
                }
                .store(in: &subs)
            addSubview(restore)
            
            restore.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            restore.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        }
    }
}
