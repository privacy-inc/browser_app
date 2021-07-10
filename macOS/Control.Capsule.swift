import AppKit

extension Control {
    final class Capsule: Control {
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .callout)
            text.textColor = .labelColor
            self.text = text
            
            super.init(layer: true)
            layer!.cornerRadius = 16
            
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 30).isActive = true
            rightAnchor.constraint(equalTo: text.rightAnchor, constant: 28).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 28).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
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
