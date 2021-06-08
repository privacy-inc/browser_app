import AppKit

extension Window.Error {
    final class Option: Control {
        private weak var image: Image!
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(icon: String, title: String) {
            let image = Image(icon: icon)
            image.symbolConfiguration = .init(textStyle: .title3)
            self.image = image
            
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            self.text = text
            
            super.init(layer: false)
            addSubview(image)
            addSubview(text)
            
            widthAnchor.constraint(equalToConstant: 120).isActive = true
            heightAnchor.constraint(equalToConstant: 36).isActive = true
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 5).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                image.contentTintColor = .controlAccentColor
                text.textColor = .controlAccentColor
            case .highlighted:
                image.contentTintColor = .labelColor
                text.textColor = .labelColor
            default:
                image.contentTintColor = .secondaryLabelColor
                text.textColor = .secondaryLabelColor
            }
        }
    }
}
