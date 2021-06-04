import AppKit

extension New {
    final class Option: Control {
        private weak var image: NSImageView!
        
        required init?(coder: NSCoder) { nil }
        init(icon: String) {
            let image = NSImageView(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.symbolConfiguration = .init(textStyle: .title2)
            self.image = image
            
            super.init(layer: true)
            layer!.cornerRadius = 9
            
            addSubview(image)
            widthAnchor.constraint(equalToConstant: 40).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                image.contentTintColor = .white
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.5).cgColor
            case .highlighted:
                image.contentTintColor = .white
                layer!.backgroundColor = NSColor.controlAccentColor.cgColor
            default:
                layer!.backgroundColor = .clear
                image.contentTintColor = .labelColor
            }
        }
    }
}
