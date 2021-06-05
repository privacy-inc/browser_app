import AppKit

extension Control {
    final class Capsule: Control {
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .callout)
            self.text = text
            
            super.init(layer: true)
            layer!.cornerRadius = 16
            
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 32).isActive = true
            rightAnchor.constraint(equalTo: text.rightAnchor, constant: 20).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                layer!.backgroundColor = NSColor.controlBackgroundColor.withAlphaComponent(0.4).cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.7).cgColor
            default:
                layer!.backgroundColor = NSColor.controlAccentColor.cgColor
                text.textColor = .white
            }
        }
    }
}
