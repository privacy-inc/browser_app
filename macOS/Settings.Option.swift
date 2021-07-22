import AppKit

extension Settings {
    class Option: Control {
        private(set) weak var image: Image!
        private(set) weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String, image: String) {
            let image = Image(icon: image)
            image.symbolConfiguration = .init(textStyle: .body)
            image.contentTintColor = .labelColor
            self.image = image
            
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = .labelColor
            self.text = text
            
            super.init(layer: true)
            layer!.cornerRadius = 4
            
            addSubview(image)
            addSubview(text)
            
            widthAnchor.constraint(equalToConstant: 185).isActive = true
            heightAnchor.constraint(equalToConstant: 34).isActive = true
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
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
    }
}
