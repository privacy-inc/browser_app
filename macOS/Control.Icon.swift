import AppKit

extension Control {
    final class Icon: Control {
        private(set) weak var icon: NSImageView!
        
        required init?(coder: NSCoder) { nil }
        init(icon: String) {
            super.init()
            
            let icon = NSImageView(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.contentTintColor = .secondaryLabelColor
            addSubview(icon)
            self.icon = icon
            
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                icon.contentTintColor = .controlAccentColor
            case .highlighted:
                icon.contentTintColor = .labelColor
            default:
                icon.contentTintColor = .secondaryLabelColor
            }
        }
    }
}
