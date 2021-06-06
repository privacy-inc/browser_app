import AppKit

class Info: NSWindow {
    init(title: String, message: String) {
        super.init(contentRect: .init(x: 0, y: 0, width: 440, height: 600),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        self.title = title
        center()
        
        let text = Text()
        text.stringValue = message
        text.isSelectable = true
        text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .light)
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentView!.addSubview(text)
        
        text.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        text.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 50).isActive = true
        text.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -50).isActive = true
        text.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -50).isActive = true
    }
}
