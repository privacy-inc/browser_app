import AppKit
import Combine
import Sleuth
import StoreKit
import WebKit
import CoreLocation

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate, CLLocationManagerDelegate  {
    let location = CurrentValueSubject<CLLocation?, Never>(nil)
    let pages = CurrentValueSubject<[Page], Never>([])
    let blocked = PassthroughSubject<Void, Never>()
    let decimal = NumberFormatter()
    private var sub: AnyCancellable?
    private var manager: CLLocationManager?
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
        decimal.numberStyle = .decimal
        
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handle(_:_:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }
    
    func forget() {
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        [WKWebsiteDataStore.default(), WKWebsiteDataStore.nonPersistent()].forEach {
            $0.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {
                $0.forEach {
                    WKWebsiteDataStore.default().removeData(ofTypes: $0.dataTypes, for: [$0]) { }
                }
            }
            $0.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast) { }
        }
    }
    
    func refresh() {
        sub = FileManager.pages.receive(on: DispatchQueue.main).sink {
            guard $0 != self.pages.value else { return }
            self.pages.value = $0
        }
    }
    
    func geolocation() {
        guard manager == nil, location.value == nil else { return }
        manager = .init()
        manager!.delegate = self
        manager!.requestLocation()
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
    
    func applicationDidFinishLaunching(_: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if let created = Defaults.created {
                if !Defaults.rated && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 4 {
                    Defaults.rated = true
                    SKStoreReviewController.requestReview()
                }
            } else {
                Defaults.created = .init()
            }
        }
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
    
    func locationManager(_: CLLocationManager, didUpdateLocations: [CLLocation]) {
        location.value = didUpdateLocations.first
        manager = nil
    }
    
    func locationManager(_: CLLocationManager, didFailWithError: Error) { }
    
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
