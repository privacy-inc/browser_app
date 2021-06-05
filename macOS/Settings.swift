import AppKit
import Combine

final class Settings: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 500, height: 480),
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        titlebarAppearsTransparent = true
        isReleasedWhenClosed = false
        setFrameAutosaveName("Settings")
        title = NSLocalizedString("Settings", comment: "")
        center()
        
        let bar = NSTitlebarAccessoryViewController()
        bar.view = Title()
        bar.layoutAttribute = .top
        addTitlebarAccessoryViewController(bar)
        
        let tab = NSTabView()
        tab.translatesAutoresizingMaskIntoConstraints = false
        tab.addTabViewItem(General())
        tab.addTabViewItem(Features())
        tab.addTabViewItem(Security())
        tab.addTabViewItem(Privacy())
        tab.addTabViewItem(Data())
        contentView!.addSubview(tab)
        
        tab.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        tab.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -10).isActive = true
        tab.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 10).isActive = true
        tab.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -10).isActive = true
    }
}
