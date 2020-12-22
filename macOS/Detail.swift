import AppKit
import Combine
import Sleuth

final class Detail: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        super.init()
        behavior = .transient
        contentSize = .init(width: 260, height: 140)
        contentViewController = .init()
        contentViewController!.view = .init()
        
        let trackers = Item(title: NSLocalizedString("Trackers blocked", comment: ""), icon: "shield.lefthalf.fill", caption: "\(browser.blocked.value.count)")
        contentViewController!.view.addSubview(trackers)
        
        trackers.click.sink {
            Trackers().makeKeyAndOrderFront(nil)
        }.store(in: &subs)
        
        trackers.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 40).isActive = true
        trackers.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
        trackers.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
