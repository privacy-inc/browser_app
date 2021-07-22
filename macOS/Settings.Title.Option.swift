import AppKit

extension Settings.Title {
    final class Option: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String, image: String) {
            let image = Image(icon: image)
            image.symbolConfiguration = .init(textStyle: .body)
            image.contentTintColor = .labelColor
            
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .callout)
            text.textColor = .labelColor
            
            super.init(layer: true)
            layer!.cornerRadius = 5
            
            addSubview(image)
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 32).isActive = true
            rightAnchor.constraint(equalTo: image.rightAnchor, constant: 15).isActive = true
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.leftAnchor.constraint(equalTo: text.rightAnchor, constant: 15).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
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
    }
}
