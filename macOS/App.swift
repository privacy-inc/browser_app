import AppKit
import Combine
import Sleuth

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate  {
    let pages = CurrentValueSubject<[Page], Never>([])
    let blocked = PassthroughSubject<Void, Never>()
    private var sub: AnyCancellable?
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
        
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handle(_:_:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }
    
    func refresh() {
        sub = FileManager.pages.receive(on: DispatchQueue.main).sink {
            guard $0 != self.pages.value else { return }
            self.pages.value = $0
        }
    }
    
    func application(_: NSApplication, open: [URL]) {
        open.forEach(tab)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        false
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        mainMenu = Menu()
        newWindow()
    }
    
    func window(_ url: URL) {
        let window = Window()
        window.makeKeyAndOrderFront(nil)
        window.browser.page.value = .init(url: url)
        window.browser.browse.send(url)
    }
    
    func tab(_ url: URL) {
        guard let key = keyWindow as? Window,
              key.browser.page.value == nil
        else {
            if let empty = windows
                .compactMap({ $0 as? Window })
                .first(where: { $0.browser.page.value == nil }) {
                empty.browser.browse.send(url)
            } else if let window = windows.compactMap({ $0 as? Window }).first {
                window.newTab(url)
            } else {
                window(url)
            }
            return
        }
        key.browser.browse.send(url)
    }
    
    @objc func newWindow() {
        Window().makeKeyAndOrderFront(nil)
    }
    
    @objc func newTab() {
        guard let window = keyWindow as? Window ?? windows.compactMap({ $0 as? Window }).first else {
            newWindow()
            return
        }
        window.newTab(nil)
    }
    
    @objc func closeWindow() {
        keyWindow.map {
            if let tabs = $0.tabbedWindows {
                tabs.forEach {
                    $0.close()
                }
            } else {
                $0.close()
            }
        }
    }
    
    @objc func preferences() {
        (windows.first { $0 is Preferences } ?? Preferences()).makeKeyAndOrderFront(nil)
    }
    
    @objc func trackers() {
        (windows.first { $0 is Trackers } ?? Trackers()).makeKeyAndOrderFront(nil)
    }
    
    @objc private func handle(_ event: NSAppleEventDescriptor, _ reply: NSAppleEventDescriptor) {
        event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue?.removingPercentEncoding
            .flatMap { URL(string: $0) }
            .map(tab)
    }
}
