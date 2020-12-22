import AppKit

extension Detail {
    final class Item: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String, icon: String, caption: String? = nil) {
            super.init()
            wantsLayer = true
            layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.3).cgColor
            layer!.cornerRadius = 6
            
            let text = Text()
            text.stringValue = title
            text.font = .systemFont(ofSize: 12, weight: .regular)
            addSubview(text)
            
            let icon = NSImageView(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.imageScaling = .scaleNone
            addSubview(icon)
            
            heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            icon.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            if let caption = caption {
                let text = Text()
                text.stringValue = caption
                text.font = .systemFont(ofSize: 12, weight: .bold)
                addSubview(text)
                
                text.rightAnchor.constraint(equalTo: icon.leftAnchor, constant: -2).isActive = true
                text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
        }
    }
}
