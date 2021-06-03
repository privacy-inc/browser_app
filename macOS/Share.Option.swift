import AppKit

extension Share {
    final class Option: Control {
        private weak var image: NSImageView!
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String, image: String) {
            super.init()
            wantsLayer = true
            layer!.cornerRadius = 4
            
            let image = NSImageView(image: NSImage(systemSymbolName: image, accessibilityDescription: nil)!)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentTintColor = .secondaryLabelColor
            image.symbolConfiguration = .init(textStyle: .title3)
            addSubview(image)
            self.image = image
            
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .callout)
            addSubview(text)
            self.text = text
            
            widthAnchor.constraint(equalToConstant: 160).isActive = true
            heightAnchor.constraint(equalToConstant: 28).isActive = true
            
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
                layer!.backgroundColor = NSColor.controlBackgroundColor.cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                layer!.backgroundColor = .clear
                image.contentTintColor = .secondaryLabelColor
                text.textColor = .secondaryLabelColor
            }
        }
    }
}
