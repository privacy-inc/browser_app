import AppKit
import Combine
import Sleuth

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate  {
    let pages = CurrentValueSubject<[Page], Never>([])
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        false
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        mainMenu = Menu()
        newWindow()
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        FileManager.pages.combineLatest(Timer.publish(every: 10, tolerance: 10, on: .main, in: .common).autoconnect()).receive(on: DispatchQueue.main).sink {
            self.pages.value = $0.0
            print("get pages \($0.0.count)")
        }.store(in: &subs)
    }
    
    @objc func newWindow() {
        Window().makeKeyAndOrderFront(nil)
    }
    
    @objc func newTab() {
        guard let window = keyWindow as? Window else {
            newWindow()
            return
        }
        window.newTab()
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
}
