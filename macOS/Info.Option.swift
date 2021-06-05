import AppKit

extension Info {
    final class Option: Control {
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
            
            widthAnchor.constraint(equalToConstant: 100).isActive = true
            heightAnchor.constraint(equalToConstant: 32).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
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
