import AppKit

extension Window.Error {
    final class Option: Control {
        private weak var image: Image!
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(icon: String, title: String) {
            let image = Image(icon: icon)
            image.symbolConfiguration = .init(textStyle: .body)
            self.image = image
            
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            self.text = text
            
            super.init(layer: true)
            layer!.cornerRadius = 4
            layer!.borderWidth = 1
            addSubview(image)
            addSubview(text)
            
            widthAnchor.constraint(equalToConstant: 130).isActive = true
            heightAnchor.constraint(equalToConstant: 36).isActive = true
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                image.contentTintColor = .controlAccentColor
                text.textColor = .controlAccentColor
                layer!.borderColor = NSColor.controlAccentColor.cgColor
            case .highlighted:
                image.contentTintColor = .labelColor
                text.textColor = .labelColor
                layer!.borderColor = NSColor.labelColor.cgColor
            default:
                image.contentTintColor = .tertiaryLabelColor
                text.textColor = .secondaryLabelColor
                layer!.borderColor = NSColor.tertiaryLabelColor.cgColor
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
