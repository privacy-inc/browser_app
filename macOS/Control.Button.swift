import AppKit

extension Control {
    final class Button: Control {
        private(set) weak var icon: NSImageView!
        
        required init?(coder: NSCoder) { nil }
        init(_ icon: String) {
            super.init()
            let icon = NSImageView(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.imageScaling = .scaleNone
            addSubview(icon)
            self.icon = icon
            
            icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        final override func update() {
            switch style {
            case .blue:
                switch state {
                case .on: icon.contentTintColor = .controlAccentColor
                case .off: icon.contentTintColor = .tertiaryLabelColor
                case .selected, .highlighted: icon.contentTintColor = .labelColor
                case .pressed: icon.contentTintColor = .systemIndigo
                }
            case .none:
                super.update()
            }
        }
    }
}
