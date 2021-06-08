import AppKit
import Combine

extension Settings {
    final class Title: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            let plus = Option(title: "Privacy", image: "plus")
            plus
                .click
                .sink {
                    NSApp.store()
                }
                .store(in: &subs)
            addSubview(plus)
            
            plus.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            plus.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        }
    }
}
