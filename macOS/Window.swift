import AppKit
import Combine
import Sleuth

final class Window: NSWindow {
    let browser = Browser()
    private weak var web: Web!
    private weak var searchbar: Searchbar!
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: NSScreen.main!.frame.width * 0.6, height: NSScreen.main!.frame.height),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
        minSize = .init(width: 400, height: 200)
        toolbar = .init()
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
        tabbingMode = .disallowed
        
        let searchbar = Searchbar(browser: browser)
        self.searchbar = searchbar
        initialFirstResponder = searchbar.field
        let accesory = NSTitlebarAccessoryViewController()
        accesory.view = searchbar
        accesory.layoutAttribute = .top
        addTitlebarAccessoryViewController(accesory)
        
        
//        _tab.selected.sink { [weak self] in
//            guard let self = self else { return }
//            guard $0.page.value == nil else {
//
//                return
//            }
//            guard !self.contentView!.subviews.contains(where: { $0 is History }) else { return }
//            let history = History()
//            self.contentView!.addSubview(history)
//            history.topAnchor.constraint(equalTo: self.contentView!.topAnchor, constant: 80).isActive = true
//            history.bottomAnchor.constraint(equalTo: self.contentView!.bottomAnchor).isActive = true
//            history.leftAnchor.constraint(equalTo: self.contentView!.leftAnchor).isActive = true
//            history.rightAnchor.constraint(equalTo: self.contentView!.rightAnchor).isActive = true
//        }.store(in: &subs)
        
//        browser.save.combineLatest(browser.page).debounce(for: .seconds(1), scheduler: dispatch).sink {
//            $0.1.map(FileManager.default.save)
//        }.store(in: &subs)
//
        browser.browse.sink { [weak self] in
            guard let self = self else { return }
            if self.browser.page.value == nil && self.web == nil {
                self.browser.page.value = .init(url: $0)
                let web = Web(browser: self.browser)
                self.web = web
                self.contentView!.addSubview(web)
                web.topAnchor.constraint(equalTo: self.contentView!.safeAreaLayoutGuide.topAnchor).isActive = true
                web.bottomAnchor.constraint(equalTo: self.contentView!.safeAreaLayoutGuide.bottomAnchor).isActive = true
                web.leftAnchor.constraint(equalTo: self.contentView!.safeAreaLayoutGuide.leftAnchor).isActive = true
                web.rightAnchor.constraint(equalTo: self.contentView!.safeAreaLayoutGuide.rightAnchor).isActive = true
            }
            self.web.open($0)
        }.store(in: &subs)
        
        browser.page.debounce(for: .seconds(1), scheduler: DispatchQueue.main).sink { [weak self] in
            self?.tab.title = $0?.title
        }.store(in: &subs)
    }
    
    func newTab() {
        let new = Window()
        addTabbedWindow(new, ordered: .above)
        tabGroup?.selectedWindow = new
    }
    
    override func mouseUp(with: NSEvent) {
        guard with.clickCount >= 2 else {
            super.mouseUp(with: with)
            return
        }
        performZoom(nil)
    }
    
    @objc func openLocation() {
        makeFirstResponder(searchbar.field)
    }
    
    @objc func copyLink() {
        browser.page.value.map {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString($0.url.absoluteString, forType: .string)
        }
    }
}
