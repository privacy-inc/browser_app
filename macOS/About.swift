import AppKit

final class About: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 300, height: 300),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .hudWindow
        contentView = content
        center()
        setFrameAutosaveName("About")
        
        let image = Image(named: "about")
        image.contentTintColor = .labelColor
        content.addSubview(image)
        
        let name = Text()
        name.stringValue = "Privacy"
        name.font = .preferredFont(forTextStyle: .largeTitle)
        name.textColor = .labelColor
        content.addSubview(name)
        
        let version = Text()
        version.stringValue = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        version.font = .preferredFont(forTextStyle: .title2)
        version.textColor = .tertiaryLabelColor
        content.addSubview(version)
        
        image.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        name.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        name.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        version.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
        version.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
    }
}
