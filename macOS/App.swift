import AppKit
import StoreKit
import Combine
import Archivable
import Sleuth

let session = Session()
let cloud = Cloud.new
let tabber = Tab()
let purchases = Purchases()

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate {
    static let dark = NSApp.windows.first?.effectiveAppearance == .init(named: .darkAqua)
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
        
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handle(_:_:)),
            forEventClass: .init(kInternetEventClass),
            andEventID: .init(kAEGetURL)
        )
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        mainMenu = Menu()
        window(id: tabber.items.value.ids.first!)
    }
    
    func applicationDidFinishLaunching(_: Notification) {
//        Session.purchases.plusOne.sink {
//            Session.mutate {
//                $0.capacity += 1
//            }
//        }.store(in: &subs)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            if let created = Defaults.created {
//                if !Defaults.rated && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 4 {
//                    Defaults.rated = true
//                    SKStoreReviewController.requestReview()
//                }
//            } else {
//                Defaults.created = .init()
//            }
//        }
//
//        registerForRemoteNotifications()
    }
    
    func applicationDidBecomeActive(_: Notification) {
        cloud.pull.send()
    }
    
    func application(_: NSApplication, didReceiveRemoteNotification: [String : Any]) {
        cloud.pull.send()
    }
    
    func applicationShouldHandleReopen(_: NSApplication, hasVisibleWindows: Bool) -> Bool {
        if !hasVisibleWindows {
            newWindow()
        }
        return true
    }

    @objc private func handle(_ event: NSAppleEventDescriptor, _: NSAppleEventDescriptor) {
        event
            .paramDescriptor(forKeyword: keyDirectObject)
            .flatMap(\.stringValue?.removingPercentEncoding)
            .flatMap(URL.init(string:))
            .map(open(tab:))
    }
}
