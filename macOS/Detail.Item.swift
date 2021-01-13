import AppKit

extension Detail {
    final class Item: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String, icon: String, caption: String? = nil) {
            super.init()
            let text = Text()
            text.stringValue = title
            text.font = .systemFont(ofSize: 14, weight: .medium)
            addSubview(text)
            
            let icon = NSImageView(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.symbolConfiguration = .init(textStyle: .title1)
            icon.contentTintColor = .labelColor
            addSubview(icon)
            
            heightAnchor.constraint(equalToConstant: 60).isActive = true
            widthAnchor.constraint(equalToConstant: 340).isActive = true
            
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            icon.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            if let caption = caption {
                let text = Text()
                text.stringValue = caption
                text.font = .monospacedSystemFont(ofSize: 16, weight: .bold)
                addSubview(text)
                
                text.rightAnchor.constraint(equalTo: icon.leftAnchor, constant: -4).isActive = true
                text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
            
            update()
        }
        
        override func update() {
            switch state {
            case .highlighted:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.3).cgColor
            case .pressed:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.5).cgColor
            default:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.1).cgColor
            }
        }
    }
}
