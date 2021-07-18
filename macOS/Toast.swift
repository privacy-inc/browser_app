import AppKit

final class Toast: NSPanel {
    class func show(message: Message) {
        let toast = Self(message: message)
        toast.orderFrontRegardless()
        toast.setFrameTopLeftPoint(.init(x: (NSScreen.main?.frame.width ?? 600) - toast.frame.width - 10,
                                         y: (NSScreen.main?.frame.height ?? 400) - 35))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) { [weak toast] in
            toast?.close()
        }
    }
    
    private init(message: Message) {
        super.init(contentRect: .init(origin: .zero, size: .init(width: 300, height: 70)), styleMask: [.borderless], backing: .buffered, defer: true)
        isMovable = false
        backgroundColor = .clear
        isOpaque = false
        hasShadow = true
        animationBehavior = .alertPanel
        level = .floating
        
        let content = NSVisualEffectView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.material = .menu
        content.state = .active
        content.wantsLayer = true
        content.layer!.cornerRadius = 10
        contentView!.addSubview(content)
        
        let icon = Image(icon: message.icon)
        icon.symbolConfiguration = .init(textStyle: .title3)
        icon.contentTintColor = .labelColor
        content.addSubview(icon)
        
        let title = Text()
        title.stringValue = message.title
        title.textColor = .labelColor
        title.font = .preferredFont(forTextStyle: .body)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        content.addSubview(title)
        
        content.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        content.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        
        icon.centerYAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
        icon.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 30).isActive = true
        
        title.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: content.rightAnchor, constant: -30).isActive = true
        title.centerYAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
    }
    
    override func mouseDown(with: NSEvent) {
        guard with.clickCount == 1 else { return }
        close()
    }
}
