import AppKit

extension Share {
    final class Option: Control {
        private weak var image: NSImageView!
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String, image: String) {
            let image = NSImageView(image: NSImage(systemSymbolName: image, accessibilityDescription: nil)!)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentTintColor = .secondaryLabelColor
            image.symbolConfiguration = .init(textStyle: .title3)
            self.image = image
            
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .callout)
            self.text = text
            
            super.init(layer: true)
            layer!.cornerRadius = 4
            
            addSubview(image)
            addSubview(text)
            
            widthAnchor.constraint(equalToConstant: 180).isActive = true
            heightAnchor.constraint(equalToConstant: 34).isActive = true
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                image.contentTintColor = .labelColor
                text.textColor = .labelColor
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.3).cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
            default:
                layer!.backgroundColor = NSColor.controlBackgroundColor.cgColor
                image.contentTintColor = .secondaryLabelColor
                text.textColor = .secondaryLabelColor
            }
        }
    }
}
