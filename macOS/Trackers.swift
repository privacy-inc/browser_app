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
        
        let barTop = NSTitlebarAccessoryViewController()
        barTop.view = Top()
        barTop.layoutAttribute = .top
        addTitlebarAccessoryViewController(barTop)
        
        let bottom = Bottom()
        let barBottom = NSTitlebarAccessoryViewController()
        barBottom.view = bottom
        barBottom.view.frame.size.height = 60
        barBottom.layoutAttribute = .bottom
        addTitlebarAccessoryViewController(barBottom)
        
        let content = NSView()
        contentView = content
        
        let side = NSVisualEffectView()
        side.state = .active
        side.translatesAutoresizingMaskIntoConstraints = false
        side.material = .menu
        content.addSubview(side)
        
        let display = NSVisualEffectView()
        display.translatesAutoresizingMaskIntoConstraints = false
        display.wantsLayer = true
        content.addSubview(display)
        
        let show = PassthroughSubject<[Date]?, Never>()
        
        let list = List(sorted: bottom.sorted, show: show)
        content.addSubview(list)
        
        side.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        side.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        side.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        side.widthAnchor.constraint(equalToConstant: List.width + List.insets2).isActive = true
        
        display.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        display.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        display.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        display.leftAnchor.constraint(equalTo: side.rightAnchor).isActive = true
        
        list.topAnchor.constraint(equalTo: side.topAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: side.bottomAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: side.leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: side.rightAnchor).isActive = true
        
        subscription = show
            .removeDuplicates()
            .sink {
                display
                    .layer!
                    .sublayers
                    .map {
                        $0.forEach {
                            $0.removeFromSuperlayer()
                        }
                    }
                
                guard let dates = $0 else { return }
                display.layer!.addSublayer(Activity.Chart(frame: display.layer!.bounds.insetBy(dx: 40, dy: 40), values: dates.plotter))
            }
    }
}
