import AppKit

extension Preferences {
    final class Button: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            super.init()
            let text = Text()
            text.stringValue = title
            text.font = .systemFont(ofSize: 12, weight: .regular)
            addSubview(text)
            
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            update()
        }
        
        override func update() {
            switch state {
            case .highlighted:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.5).cgColor
            case .pressed:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.6).cgColor
            default:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.3).cgColor
            }
        }
    }
}
