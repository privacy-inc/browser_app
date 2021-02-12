import AppKit
import Combine
import Sleuth

final class Detail: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        super.init()
        behavior = .transient
        contentSize = .init(width: 440, height: 540)
        contentViewController = .init()
        contentViewController!.view = .init()
        
        let chart = Chart()
        contentViewController!.view.addSubview(chart)
        
        let trackers = Tool(title: NSLocalizedString("Trackers blocked", comment: ""), icon: "shield.lefthalf.fill", caption: (NSApp as! App).decimal.string(from: .init(value: Share.blocked.count)))
        trackers.click.sink {
            (NSApp as! App).trackers()
        }.store(in: &subs)
        contentViewController!.view.addSubview(trackers)
        
        let forget = Tool(title: NSLocalizedString("Forget", comment: ""), icon: "flame.fill")
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
        
        [trackers, forget].forEach {
            $0.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 50).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 340).isActive = true
        }
        
        chart.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 40).isActive = true
        chart.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 50).isActive = true
        
        trackers.topAnchor.constraint(equalTo: chart.bottomAnchor, constant: 60).isActive = true
        forget.topAnchor.constraint(equalTo: trackers.bottomAnchor, constant: 10).isActive = true
    }
}
