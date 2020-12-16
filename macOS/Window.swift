import AppKit
import Combine
import Sleuth

final class Window: NSWindow {
    private weak var web: Tab!
    private var subs = Set<AnyCancellable>()
    private let _tab = Tab()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: NSScreen.main!.frame.width / 2, height: NSScreen.main!.frame.height),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
        minSize = .init(width: 380, height: 200)
        toolbar = .init()
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
//        tab.title = "shisus"
        tabbingMode = .preferred
//
//        addTabbedWindow(NSWindow(), ordered: .below)
        
        let searchbar = Searchbar(tab: _tab)
        initialFirstResponder = searchbar.field
        let accesory = NSTitlebarAccessoryViewController()
        accesory.view = searchbar
        accesory.layoutAttribute = .top
        addTitlebarAccessoryViewController(accesory)
        
        
        _tab.selected.sink { [weak self] in
            guard let self = self else { return }
            guard $0.page.value == nil else {
                
                return
            }
            guard !self.contentView!.subviews.contains(where: { $0 is History }) else { return }
            let history = History()
            self.contentView!.addSubview(history)
            history.topAnchor.constraint(equalTo: self.contentView!.topAnchor, constant: 80).isActive = true
            history.bottomAnchor.constraint(equalTo: self.contentView!.bottomAnchor).isActive = true
            history.leftAnchor.constraint(equalTo: self.contentView!.leftAnchor).isActive = true
            history.rightAnchor.constraint(equalTo: self.contentView!.rightAnchor).isActive = true
        }.store(in: &subs)
        
//        browser.save.combineLatest(browser.page).debounce(for: .seconds(1), scheduler: dispatch).sink {
//            $0.1.map(FileManager.default.save)
//        }.store(in: &subs)
//
//        browser.browse.sink { [weak self] in
//            guard let self = self else { return }
//            if browser.page.value == nil && self.web == nil {
//                browser.page.value = .init(url: $0)
//                let web = Tab(browser: browser)
//                self.web = web
//                self.contentView!.addSubview(web)
//                web.topAnchor.constraint(equalTo: tabbar.bottomAnchor).isActive = true
//                web.bottomAnchor.constraint(equalTo: self.contentView!.bottomAnchor).isActive = true
//                web.leftAnchor.constraint(equalTo: self.contentView!.leftAnchor).isActive = true
//                web.rightAnchor.constraint(equalTo: self.contentView!.rightAnchor).isActive = true
//            }
//            self.web.open($0)
//        }.store(in: &subs)
    }
}
