import AppKit

extension Trackers {
    final class Title: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            let icon = Image(icon: "shield.lefthalf.fill")
            icon.contentTintColor = .tertiaryLabelColor
            icon.symbolConfiguration = .init(textStyle: .title2)
            addSubview(icon)
            
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            icon.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        }
        
        override func hitTest(_: NSPoint) -> NSView? {
            nil
        }
    }
}
