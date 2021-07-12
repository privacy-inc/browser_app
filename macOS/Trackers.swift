import AppKit
import Combine

final class Trackers: NSWindow {
    private var subscription: AnyCancellable?
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 800, height: 500),
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        title = NSLocalizedString("Trackers", comment: "")
        center()
        setFrameAutosaveName("Trackers")
        titlebarAppearsTransparent = true
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .popover
        contentView = content
        
        let bar = Bar()
        let accessory = NSTitlebarAccessoryViewController()
        accessory.view = bar
        accessory.layoutAttribute = .top
        addTitlebarAccessoryViewController(accessory)
        
        let horizontal = Separator(mode: .horizontal)
        content.addSubview(horizontal)
        
        let vertical = Separator(mode: .vertical)
        content.addSubview(vertical)
        
        let show = PassthroughSubject<[Date]?, Never>()
        
        let list = List(sorted: bar.sorted, show: show)
        content.addSubview(list)
        
        list.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        list.widthAnchor.constraint(equalToConstant: List.width + List.insets2).isActive = true
        
        vertical.topAnchor.constraint(equalTo: list.topAnchor).isActive = true
        vertical.bottomAnchor.constraint(equalTo: list.bottomAnchor).isActive = true
        vertical.rightAnchor.constraint(equalTo: list.rightAnchor).isActive = true
        
        horizontal.bottomAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        horizontal.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        horizontal.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        
        let frame = CGRect(x: List.width + List.insets2, y: 0, width: self.frame.width - (List.width + List.insets2), height: self.frame.height)
        
        subscription = show
            .removeDuplicates()
            .sink {
                content
                    .subviews
                    .filter {
                        $0 is Chart
                    }
                    .forEach {
                        $0.removeFromSuperview()
                    }
                
                guard let dates = $0 else { return }
                content.addSubview(Chart(frame: frame, first: dates.first ?? .init(), values: dates.plotter))
            }
    }
}
