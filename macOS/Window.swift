import AppKit
import Combine

final class Window: NSWindow {
    let id: UUID
    private(set) weak var search: Search!
    private var subs = Set<AnyCancellable>()
    
    init(id: UUID) {
        self.id = id
        super.init(contentRect: .init(x: 0,
                                      y: 0,
                                      width: NSScreen.main!.frame.width * 0.5,
                                      height: NSScreen.main!.frame.height),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        minSize = .init(width: 400, height: 200)
        toolbar = .init()
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
        tab.title = NSLocalizedString("Privacy", comment: "")
        tabbingMode = .preferred
        toggleTabBar(nil)
        
        let search = Search(id: id)
        let bar = NSTitlebarAccessoryViewController()
        bar.view = search
        bar.layoutAttribute = .top
        addTitlebarAccessoryViewController(bar)
        initialFirstResponder = search.field
        self.search = search
        
        tabber
            .items
            .map {
                $0[state: id]
            }
            .removeDuplicates()
            .sink { [weak self] in
                switch $0 {
                case .new:
                    self?.show(New(id: id))
                case let .browse(browse):
                    let web = (tabber.items.value[web: id] as? Web) ?? Web(id: id, browse: browse)
                    if tabber.items.value[web: id] == nil {
                        tabber.update(id, web: web)
                    }
                    self?.show(web)
                case let .error(browse, error):
                    self?.show(Error(id: id, browse: browse, error: error))
                }
            }
            .store(in: &subs)
        
        cloud
            .archive
            .combineLatest(tabber
                            .items
                            .map {
                                $0[state: id]
                                    .browse
                            }
                            .compactMap {
                                $0
                            }
                            .removeDuplicates())
            .map {
                $0.0
                    .page($0.1)
                    .title
            }
            .filter {
                !$0.isEmpty
            }
            .removeDuplicates()
            .sink { [weak self] in
                self?.tab.title = $0
            }
            .store(in: &subs)
        
        session
            .close
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.close()
            }
            .store(in: &subs)
    }
    
    override func close() {
        tabber.close(id)
        super.close()
    }
    
    override func resignKey() {
        super.resignKey()
        childWindows?.forEach {
                removeChildWindow($0)
                $0.orderOut(nil)
            }
    }
    
    override func becomeMain() {
        super.becomeMain()
        dim(opacity: 1)
    }
    
    override func resignMain() {
        super.resignMain()
        dim(opacity: 0.6)
    }
    
    override func newWindowForTab(_: Any?) {
        NSApp.newTab()
    }
    
    @objc func location() {
        search.field.selectText(nil)
    }
    
    @objc func shut() {
        if let tabs = tabbedWindows {
            tabs.forEach {
                $0.close()
            }
        } else {
            close()
        }
    }
    
    private func show(_ view: NSView) {
        contentView!
            .subviews
            .forEach {
                $0.removeFromSuperview()
            }
        
        view.layer!.cornerRadius = 9
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(view)
        
        view.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
        view.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 1).isActive = true
        view.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -1).isActive = true
    }
    
    private func dim(opacity: CGFloat) {
        titlebarAccessoryViewControllers.first!.view.alphaValue = opacity
    }
}
