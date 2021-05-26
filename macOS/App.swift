import AppKit
import StoreKit
import Combine
import Archivable

let session = Session()
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
//        Session.decimal.numberStyle = .decimal
//        Session.percentage.numberStyle = .percent
//        
        mainMenu = Menu()
        window()
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
//        Repository.memory.pull.send()
    }
    
    func application(_: NSApplication, didReceiveRemoteNotification: [String : Any]) {
//        Repository.memory.pull.send()
    }
    
    @objc func preferences() {
//        (windows.first { $0 is Preferences } ?? Preferences()).makeKeyAndOrderFront(nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @objc private func handle(_ event: NSAppleEventDescriptor, _: NSAppleEventDescriptor) {
        event
            .paramDescriptor(forKeyword: keyDirectObject)
            .flatMap(\.stringValue?.removingPercentEncoding)
            .flatMap(URL.init(string:))
            .map(open(tab:))
    }
}
