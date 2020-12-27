import AppKit
import Combine
import Sleuth

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate  {
    let pages = CurrentValueSubject<[Page], Never>([])
    let blocked = CurrentValueSubject<Set<String>, Never>([])
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func refresh() {
        var sub: AnyCancellable?
        sub = FileManager.pages.receive(on: DispatchQueue.main).sink {
            sub?.cancel()
            guard $0 != self.pages.value else { return }
            self.pages.value = $0
        }
    }
    
    func application(_: NSApplication, open: [URL]) {
        open.first.map(window)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        false
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        mainMenu = Menu()
        newWindow()
        
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handle(_:_:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }
    
    @objc func newWindow() {
        Window().makeKeyAndOrderFront(nil)
    }
    
    @objc func window(_ url: URL) {
        let window = Window()
        window.makeKeyAndOrderFront(nil)
        window.browser.page.value = .init(url: url)
        window.browser.browse.send(url)
    }
    
    @objc func newTab() {
        guard let window = keyWindow as? Window else {
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
            .map(window)
    }
}
