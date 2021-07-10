import AppKit

extension Window.Error {
    final class Option: Control {
        required init?(coder: NSCoder) { nil }
        init(icon: String, title: String) {
            let image = Image(icon: icon)
            image.symbolConfiguration = .init(textStyle: .body)
            image.contentTintColor = .labelColor
            
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = .labelColor
            
            super.init(layer: true)
            layer!.cornerRadius = 4
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
            case .pressed, .highlighted:
                layer!.backgroundColor = NSColor.tertiaryLabelColor.cgColor
            default:
                layer!.backgroundColor = NSColor.quaternaryLabelColor.cgColor
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
