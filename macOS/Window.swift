import AppKit
import Combine

final class Window: NSWindow {
    private weak var web: Web!
    private var subs = Set<AnyCancellable>()
    private let dispatch = DispatchQueue(label: "", qos: .utility)
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: NSScreen.main!.frame.width / 2, height: NSScreen.main!.frame.height),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
        minSize = .init(width: 380, height: 200)
        toolbar = .init()
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
        
        let tabbar = Tabbar()
        contentView!.addSubview(tabbar)
        
        tabbar.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 52).isActive = true
        tabbar.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        tabbar.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        
        let browser = Browser()
        let searchbar = Searchbar(browser: browser)
        let accesory = NSTitlebarAccessoryViewController()
        accesory.view = searchbar
        accesory.layoutAttribute = .top
        addTitlebarAccessoryViewController(accesory)
        
        browser.save.combineLatest(browser.page).debounce(for: .seconds(1), scheduler: dispatch).sink {
            $0.1.map(FileManager.default.save)
        }.store(in: &subs)
        
        browser.browse.sink { [weak self] in
            guard let self = self else { return }
            if browser.page.value == nil && self.web == nil {
                browser.page.value = .init(url: $0)
                let web = Web(browser: browser)
                self.web = web
                self.contentView!.addSubview(web)
                web.topAnchor.constraint(equalTo: tabbar.bottomAnchor).isActive = true
                web.bottomAnchor.constraint(equalTo: self.contentView!.bottomAnchor).isActive = true
                web.leftAnchor.constraint(equalTo: self.contentView!.leftAnchor).isActive = true
                web.rightAnchor.constraint(equalTo: self.contentView!.rightAnchor).isActive = true
            }
            self.web.open($0)
        }.store(in: &subs)
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
}
