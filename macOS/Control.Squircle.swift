import AppKit

extension Control {
    final class Squircle: Control {
        private weak var image: NSImageView!
        
        required init?(coder: NSCoder) { nil }
        init(icon: String) {
            let image = NSImageView(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentTintColor = .secondaryLabelColor
            image.symbolConfiguration = .init(textStyle: .title3)
            self.image = image
            
            super.init(layer: true)
            layer!.cornerRadius = 8
            
            addSubview(image)
            widthAnchor.constraint(equalToConstant: 30).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                image.contentTintColor = .labelColor
                layer!.backgroundColor = NSColor.controlBackgroundColor.cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                layer!.backgroundColor = .clear
                image.contentTintColor = .secondaryLabelColor
            }
        }
    }
}
