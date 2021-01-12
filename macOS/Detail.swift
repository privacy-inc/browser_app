import AppKit
import Combine
import Sleuth

final class Detail: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        super.init()
        behavior = .transient
        contentSize = .init(width: 440, height: 480)
        contentViewController = .init()
        contentViewController!.view = .init()
        
        let chart = Chart()
        contentViewController!.view.addSubview(chart)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let trackers = Item(title: NSLocalizedString("Trackers blocked", comment: ""), icon: "shield.lefthalf.fill", caption: formatter.string(from: .init(value: Share.blocked.count)))
        trackers.click.sink {
            (NSApp as! App).trackers()
        }.store(in: &subs)
        contentViewController!.view.addSubview(trackers)
        
        let forget = Item(title: NSLocalizedString("Forget", comment: ""), icon: "flame")
        forget.click.sink { [weak self] in
            FileManager.forget()
            (NSApp as! App).forget()
            Share.history = []
            Share.chart = []
            Share.blocked = []
            (NSApp as! App).refresh()
            self?.close()
        }.store(in: &subs)
        contentViewController!.view.addSubview(forget)
        
        chart.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 40).isActive = true
        chart.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 50).isActive = true
        
        trackers.topAnchor.constraint(equalTo: chart.bottomAnchor, constant: 60).isActive = true
        trackers.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 50).isActive = true
        
        forget.topAnchor.constraint(equalTo: trackers.bottomAnchor, constant: 10).isActive = true
        forget.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 50).isActive = true
    }
}
