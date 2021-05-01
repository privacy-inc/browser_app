import AppKit
import Combine
import Sleuth
import StoreKit
import WebKit
import CoreLocation

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate, CLLocationManagerDelegate  {
    let location = CurrentValueSubject<CLLocation?, Never>(nil)
    let decimal = NumberFormatter()
    private var manager: CLLocationManager?
    private var subs = Set<AnyCancellable>()
    
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
    
    func geolocation() {
        guard manager == nil, location.value == nil else { return }
        manager = .init()
        manager!.delegate = self
        manager!.requestLocation()
    }
    
    func application(_: NSApplication, open: [URL]) {
        open.forEach(tab)
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        mainMenu = Menu()
        newWindow()
        
        Synch
            .cloud
            .archive
            .debounce(for: .seconds(1), scheduler: DispatchQueue.global(qos: .utility))
            .sink {
                guard $0 == .new else { return }
                Synch.cloud.migrate()
            }
            .store(in: &subs)
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            if let created = Defaults.created {
                if !Defaults.rated && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 4 {
                    Defaults.rated = true
                    SKStoreReviewController.requestReview()
                } else if !Defaults.premium && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 6 {
                    self?.froob()
                }
            } else {
                Defaults.created = .init()
            }
        }
        registerForRemoteNotifications()
    }
    
    func applicationDidBecomeActive(_: Notification) {
        Synch.cloud.pull.send()
    }
    
    func application(_: NSApplication, didReceiveRemoteNotification: [String : Any]) {
        Synch.cloud.pull.send()
    }
    
    func window(_ url: URL) {
        let window = Window()
        window.makeKeyAndOrderFront(nil)
        
        var sub: AnyCancellable?
        sub = Synch
            .cloud
            .navigate(url)
            .receive(on: DispatchQueue.main)
            .sink {
                sub?.cancel()
                window.browser.entry.value = $0
            }
    }
    
    func tab(_ url: URL) {
        guard let key = keyWindow as? Window,
              key.browser.entry.value == nil
        else {
            if let empty = windows
                .compactMap({ $0 as? Window })
                .first(where: { $0.browser.entry.value == nil }) {
                
                var sub: AnyCancellable?
                sub = Synch
                    .cloud
                    .navigate(url)
                    .receive(on: DispatchQueue.main)
                    .sink {
                        sub?.cancel()
                        empty.browser.entry.value = $0
                    }
                
            } else if let window = windows.compactMap({ $0 as? Window }).first {
                window.newTab(url)
            } else {
                window(url)
            }
            return
        }
        
        var sub: AnyCancellable?
        sub = Synch
            .cloud
            .navigate(url)
            .receive(on: DispatchQueue.main)
            .sink {
                sub?.cancel()
                key.browser.entry.value = $0
            }
    }
    
    func locationManager(_: CLLocationManager, didUpdateLocations: [CLLocation]) {
        location.value = didUpdateLocations.first
        manager = nil
    }
    
    func locationManager(_: CLLocationManager, didFailWithError: Error) { }
    
    func plus() {
        (windows.first { $0 is Plus } ?? Plus()).makeKeyAndOrderFront(nil)
    }
    
    func why() {
        card(title: "Why purchasing Privacy Plus?", message: """
By purchasing Privacy Plus you are supporting the development and research necessary to fulfil our mission of bringing the most secure and private browser to iOS and macOS.

Compared to other browser alternatives, we at Privacy Inc. are an independent team, we don't have the support of big international corporations.

Furthermore, besides our In-App Purchases we don't monetize using any other mean, i.e. we don't monetize with your personal data, and we don't provide advertisements, in fact, is in our mission to remove ads from the web.
""", action: nil)
    }
    
    func alternatives() {
        card(title: "Alternatives to purchasing", message: """
We ask you to purchase Privacy Plus only if you consider it a good product, if you think is helping you in some way and if you feel the difference between a mainstream browser and Privacy.

But we are not going to force you to buy it; you will be reminded from time to time that it would be a good idea if you support us with your purchase, but you can as easily ignore the pop-up and continue using Privacy.

We believe we can help you browse securely and privatly even if you can't support us at the moment.
""", action: nil)
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
    
    private func froob() {
        card(title: "Privacy Plus", message: """
By purchasing Privacy Plus you support research and development at Privacy Inc and for Privacy Browser.

Privacy Plus is an In-App Purchase, it is non-consumable, meaning it is a 1 time only purchase and you can use it both on iOS and macOS.
""") { [weak self] in
            self?.plus()
        }
    }
    
    private func card(title: String, message: String, action: (() -> Void)?) {
        windows.filter { $0 is Plus.Card }.forEach {
            $0.close()
        }
        
        Plus.Card(title: title, message: message, action: action).makeKeyAndOrderFront(nil)
    }
    
    @objc private func handle(_ event: NSAppleEventDescriptor, _ reply: NSAppleEventDescriptor) {
        event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue?.removingPercentEncoding
            .flatMap { URL(string: $0) }
            .map(tab)
    }
}
