import AppKit
import Combine
import Sleuth

final class Window: NSWindow {
    private(set) weak var web: Web?
    let browser = Browser()
    private weak var history: History?
    private weak var issue: Issue?
    private weak var searchbar: Searchbar!
    private weak var separator: NSView!
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
        
        let separator = NSView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.wantsLayer = true
        separator.layer!.backgroundColor = .init(gray: 0, alpha: 0.1)
        contentView!.addSubview(separator)
        self.separator = separator
        
        let progress = NSView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.wantsLayer = true
        progress.layer!.backgroundColor = NSColor.controlAccentColor.cgColor
        contentView!.addSubview(progress)
        
        let history = History(browser: browser)
        add(history)
        self.history = history
        
        separator.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.rightAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        progress.topAnchor.constraint(equalTo: separator.topAnchor).isActive = true
        progress.leftAnchor.constraint(equalTo: separator.leftAnchor).isActive = true
        progress.bottomAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        
        var progressWidth: NSLayoutConstraint?
        browser.progress.sink { [weak self] in
            guard let anchor = self?.separator.widthAnchor else { return }
            progressWidth?.isActive = false
            progressWidth = progress.widthAnchor.constraint(equalTo: anchor, multiplier: .init($0))
            progressWidth?.isActive = true
        }.store(in: &subs)
        
        browser.browse.sink { [weak self] in
            guard let browser = self?.browser else { return }
            
            self?.history?.removeFromSuperview()
            self?.issue?.removeFromSuperview()
            browser.error.value = nil
            
            if browser.page.value == nil {
                browser.page.value = .init(url: $0)
            }
            
            if self?.web == nil {
                let web = Web(browser: browser)
                self?.add(web)
                self?.web = web
            }
            
            self?.web?.load(.init(url: $0))
        }.store(in: &subs)
        
        browser.error.sink { [weak self] in
            guard $0 != nil, let browser = self?.browser else { return }
            
            self?.tab.title = $0
            self?.history?.removeFromSuperview()
            self?.web?.removeFromSuperview()
            
            let issue = Issue(browser: browser)
            self?.add(issue)
            self?.issue = issue
        }.store(in: &subs)
        
        browser.page.debounce(for: .seconds(1), scheduler: DispatchQueue.main).sink { [weak self] in
            $0.map {
                guard !$0.title.isEmpty else { return }
                self?.tab.title = $0.title
            }
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
    
    private func add(_ view: NSView) {
        contentView!.addSubview(view)
        
        view.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
}
