import AppKit
import Combine

final class Window: NSWindow {
    let id: UUID
    private(set) weak var search: Search!
    private var subs = Set<AnyCancellable>()
    private let finder = NSTextFinder()
    
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
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
        tab.title = NSLocalizedString("Privacy", comment: "")
        tab.accessoryView = Tab(id: id)
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
                    self?.contentView = New(id: id)
                case let .browse(browse):
                    let web = (tabber.items.value[web: id] as? Web) ?? Web(id: id, browse: browse)
                    if tabber.items.value[web: id] == nil {
                        tabber.update(id, web: web)
                    }
                    let browser = Browser(web: web)
                    self?.finder.client = web
                    self?.finder.findBarContainer = browser
                    self?.contentView = browser
                    self?.makeFirstResponder(web)
                case let .error(browse, error):
                    self?.finder.client = nil
                    self?.finder.findBarContainer = nil
                    self?.contentView = Error(id: id, browse: browse, error: error)
                    self?.makeFirstResponder(self?.contentView)
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
                    .access
                    .string
            }
            .filter {
                !$0.isEmpty
            }
            .removeDuplicates()
            .sink { [weak self] in
                self?.tab.toolTip = $0
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
        (tabber.items.value[web: id] as? Web)?.clear()
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
        dim(opacity: 0.7)
    }
    
    override func newWindowForTab(_: Any?) {
        NSApp.newTab()
    }
    
    override func performTextFinderAction(_ sender: Any?) {
        (sender as? NSMenuItem)
            .flatMap {
                NSTextFinder.Action(rawValue: $0.tag)
            }
            .map {
                finder.performAction($0)

                switch $0 {
                case .showFindInterface:
                    finder.findBarContainer?.isFindBarVisible = true
                default: break
                }
            }
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
    
    private func dim(opacity: CGFloat) {
        search.alphaValue = opacity
    }
}
