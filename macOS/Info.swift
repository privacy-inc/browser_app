import AppKit

class Info: NSWindow {
    init(title: String, message: String, option: Option?) {
        super.init(contentRect: .init(x: 0, y: 0, width: 400, height: 600),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        self.title = title
        center()
        
        option
            .map {
                let view = NSView()
                view.addSubview($0)
                
                $0.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                $0.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
                
                let bar = NSTitlebarAccessoryViewController()
                bar.view = view
                bar.layoutAttribute = .top
                addTitlebarAccessoryViewController(bar)
            }
        
        let text = Text()
        text.stringValue = message
        text.isSelectable = true
        text.font = .preferredFont(forTextStyle: .title3)
        text.textColor = .secondaryLabelColor
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentView!.addSubview(text)
        
        text.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        text.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 30).isActive = true
        text.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -30).isActive = true
        text.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -30).isActive = true
    }
}
