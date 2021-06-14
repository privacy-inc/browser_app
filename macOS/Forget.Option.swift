import AppKit

extension Forget {
    class Option: Control {
        private weak var image: Image!
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String, image: String) {
            let image = Image(icon: image)
            image.symbolConfiguration = .init(textStyle: .title3)
            image.contentTintColor = .labelColor
            self.image = image
            
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .callout)
            text.textColor = .labelColor
            self.text = text
            
            super.init(layer: true)
            layer!.cornerRadius = 4
            
            addSubview(image)
            addSubview(text)
            
            widthAnchor.constraint(equalToConstant: 140).isActive = true
            heightAnchor.constraint(equalToConstant: 32).isActive = true
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: rightAnchor, constant: -22).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
