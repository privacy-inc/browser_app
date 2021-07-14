import AppKit

extension Bar {
    final class Squircle: Control {
        private weak var image: Image!
        
        required init?(coder: NSCoder) { nil }
        init(icon: String) {
            let image = Image(icon: icon)
            image.symbolConfiguration = .init(textStyle: .title3)
            self.image = image
            
            super.init(layer: true)
            layer!.cornerRadius = 8
            
            addSubview(image)
            widthAnchor.constraint(equalToConstant: 26).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                image.contentTintColor = .controlAccentColor
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
