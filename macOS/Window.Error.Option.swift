import AppKit

extension Window.Error {
    final class Option: Control {
        private weak var image: NSImageView!
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(icon: String, title: String) {
            let image = NSImageView(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
            image.translatesAutoresizingMaskIntoConstraints = false
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
            
            widthAnchor.constraint(equalToConstant: 120).isActive = true
            heightAnchor.constraint(equalToConstant: 34).isActive = true
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                image.contentTintColor = .controlAccentColor
                text.textColor = .controlAccentColor
                layer!.backgroundColor = NSColor.controlBackgroundColor.cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
            default:
                layer!.backgroundColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
                image.contentTintColor = .labelColor
                text.textColor = .labelColor
            }
        }
    }
}
