import AppKit

final class Button: Control {
    private(set) weak var icon: NSImageView!
    
    required init?(coder: NSCoder) { nil }
    init(icon: String) {
        super.init()
        let icon = NSImageView(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.imageScaling = .scaleNone
        addSubview(icon)
        self.icon = icon
        
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
