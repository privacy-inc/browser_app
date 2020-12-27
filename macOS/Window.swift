import AppKit
import Combine
import Sleuth

final class Window: NSWindow {
    private(set) weak var web: Web?
    let browser = Browser()
    private weak var history: History?
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
        tab.title = NSLocalizedString("New tab", comment: "")
        
        let searchbar = Searchbar(browser: browser)
        self.searchbar = searchbar
        initialFirstResponder = searchbar.field
        let accesory = NSTitlebarAccessoryViewController()
        accesory.view = searchbar
        accesory.layoutAttribute = .top
        addTitlebarAccessoryViewController(accesory)
        
        let progress = NSView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.wantsLayer = true
        progress.layer!.backgroundColor = NSColor.controlAccentColor.cgColor
        contentView!.addSubview(progress)
        
        let history = History(browser: browser)
        contentView!.addSubview(history)
        self.history = history
        
        history.topAnchor.constraint(equalTo: progress.bottomAnchor).isActive = true
        history.bottomAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.bottomAnchor).isActive = true
        history.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor).isActive = true
        history.rightAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        progress.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor).isActive = true
        progress.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor).isActive = true
        progress.heightAnchor.constraint(equalToConstant: 3).isActive = true
        var progressWidth: NSLayoutConstraint?
        
        browser.browse.sink { [weak self] in
            self?.history?.removeFromSuperview()
            guard let self = self else { return }
            
            if self.browser.page.value == nil {
                self.browser.page.value = .init(url: $0)
            }
            
            if self.web == nil {
                let web = Web(browser: self.browser)
                self.web = web
                self.contentView!.addSubview(web)
                web.topAnchor.constraint(equalTo: progress.bottomAnchor).isActive = true
                web.bottomAnchor.constraint(equalTo: self.contentView!.safeAreaLayoutGuide.bottomAnchor).isActive = true
                web.leftAnchor.constraint(equalTo: self.contentView!.safeAreaLayoutGuide.leftAnchor).isActive = true
                web.rightAnchor.constraint(equalTo: self.contentView!.safeAreaLayoutGuide.rightAnchor).isActive = true
            }
            
            self.web?.load(.init(url: $0))
        }.store(in: &subs)
        
        browser.page.debounce(for: .seconds(1), scheduler: DispatchQueue.main).sink { [weak self] in
            $0.map {
                guard !$0.title.isEmpty else { return }
                self?.tab.title = $0.title
            }
        }.store(in: &subs)
        
        browser.progress.sink { [weak self] in
            guard let self = self else { return }
            progressWidth?.isActive = false
            progressWidth = progress.widthAnchor.constraint(equalTo: self.contentView!.safeAreaLayoutGuide.widthAnchor, multiplier: .init($0))
            progressWidth?.isActive = true
        }.store(in: &subs)
        
        browser.loading.sink {
            progress.isHidden = !$0
        }.store(in: &subs)
    }
    
    func newTab(_ url: URL?) {
        let new = Window()
        addTabbedWindow(new, ordered: .above)
        tabGroup?.selectedWindow = new
        url.map {
            new.browser.page.value = .init(url: $0)
            new.browser.browse.send($0)
        }
    }
    
    func save(_ name: String, data: Data) {
        let save = NSSavePanel()
        save.nameFieldStringValue = name
        save.beginSheetModal(for: self) {
            if $0 == .OK, let url = save.url {
                try? data.write(to: url, options: .atomic)
                NSWorkspace.shared.activateFileViewerSelecting([url])
            }
        }
    }
    
    override func becomeKey() {
        super.becomeKey()
        if history != nil {
            (NSApp as! App).refresh()
        }
    }
    
    @objc func location() {
        makeFirstResponder(searchbar.field)
    }
    
    @objc func copyLink() {
        browser.page.value.map {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString($0.url.absoluteString, forType: .string)
        }
    }
}
