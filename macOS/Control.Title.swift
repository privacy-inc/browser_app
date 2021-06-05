import AppKit

extension Control {
    final class Title: Control {
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            self.text = text
            
            super.init(layer: true)
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 32).isActive = true
            rightAnchor.constraint(equalTo: text.rightAnchor, constant: 5).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                text.textColor = .controlAccentColor
            case .highlighted:
                text.textColor = .labelColor
            default:
                text.textColor = .secondaryLabelColor
            }
        }
    }
}
