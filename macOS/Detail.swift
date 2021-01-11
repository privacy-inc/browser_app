import AppKit
import Combine
import Sleuth

final class Detail: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        super.init()
        behavior = .transient
        contentSize = .init(width: 400, height: 400)
        contentViewController = .init()
        contentViewController!.view = .init()
        
        let image = NSImageView(image: NSImage(systemSymbolName: "chart.bar.xaxis", accessibilityDescription: nil)!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.symbolConfiguration = .init(textStyle: .largeTitle)
        contentViewController!.view.addSubview(image)
        
        let chart = Chart()
        contentViewController!.view.addSubview(chart)
        
        let trackers = Item(title: NSLocalizedString("Trackers blocked", comment: ""), icon: "shield.lefthalf.fill", caption: "\(Share.blocked.count)")
        contentViewController!.view.addSubview(trackers)
        
        trackers.click.sink {
            (NSApp as! App).trackers()
        }.store(in: &subs)
        
        image.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 30).isActive = true
        image.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
        
        chart.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        chart.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
        
        trackers.topAnchor.constraint(equalTo: chart.bottomAnchor, constant: 30).isActive = true
        trackers.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
        trackers.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
