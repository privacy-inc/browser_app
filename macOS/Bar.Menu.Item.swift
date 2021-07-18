import AppKit

extension Bar.Menu {
    final class Item: Control {
        private weak var image: Image!
        
        required init?(coder: NSCoder) { nil }
        init(image: String) {
            let image = Image(icon: image)
            image.symbolConfiguration = .init(pointSize: 14, weight: .regular)
            image.contentTintColor = .labelColor
            
            super.init(layer: true)
            layer!.cornerRadius = 4
            
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
                layer!.backgroundColor = NSColor.tertiaryLabelColor.cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.quaternaryLabelColor.cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
