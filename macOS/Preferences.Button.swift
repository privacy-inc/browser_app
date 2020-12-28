import AppKit

extension Preferences {
    final class Button: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String, icon: NSImage) {
            super.init()
            layer!.cornerRadius = 8
            
            let text = Text()
            text.stringValue = title
            text.font = .systemFont(ofSize: 14, weight: .regular)
            addSubview(text)
            
            let icon = NSImageView(image: icon)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.imageScaling = .scaleNone
            addSubview(icon)
            
            heightAnchor.constraint(equalToConstant: 42).isActive = true
            
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            icon.rightAnchor.constraint(equalTo: rightAnchor, constant: -18).isActive = true
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

            update()
        }
        
        override func update() {
            switch state {
            case .highlighted:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.4).cgColor
            case .pressed:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.5).cgColor
            case .off:
                layer!.backgroundColor = NSColor.underPageBackgroundColor.cgColor
            default:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.2).cgColor
            }
        }
    }
}
