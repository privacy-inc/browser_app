import AppKit

extension Control {
    final class Icon: Control {
        private(set) weak var icon: Image!
        
        required init?(coder: NSCoder) { nil }
        init(icon: String) {
            let icon = Image(icon: icon)
            self.icon = icon
            
            super.init(layer: false)
            
            addSubview(icon)
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                icon.contentTintColor = .labelColor
            case .highlighted:
                icon.contentTintColor = .secondaryLabelColor
            default:
                icon.contentTintColor = .tertiaryLabelColor
            }
        }
    }
}
