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
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        false
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        mainMenu = Menu()
        newWindow()
    }
    
    @objc func newWindow() {
        Window().makeKeyAndOrderFront(nil)
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
}
