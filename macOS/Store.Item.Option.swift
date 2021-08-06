import Foundation

extension Store.Item {
    final class Option: Control {
        private weak var image: Image!
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String, image: String) {
            let image = Image(icon: image)
            image.symbolConfiguration = .init(textStyle: .body)
            self.image = image
            
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            self.text = text
            
            super.init(layer: false)
            addSubview(image)
            addSubview(text)
            
            widthAnchor.constraint(equalToConstant: 200).isActive = true
            heightAnchor.constraint(equalToConstant: 34).isActive = true
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed, .highlighted:
                image.contentTintColor = .labelColor
                text.textColor = .labelColor
            default:
                image.contentTintColor = .secondaryLabelColor
                text.textColor = .secondaryLabelColor
            }
        }
    }
}
