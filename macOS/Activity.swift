import AppKit
import Combine

final class Activity: NSWindow {
    private var subscription: AnyCancellable?
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 500, height: 240),
                   styleMask: [.closable, .miniaturizable, .titled], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        setFrameAutosaveName("Activity")
        title = NSLocalizedString("Activity", comment: "")
        center()
        contentView!.wantsLayer = true
        contentView!.layer!.backgroundColor = NSColor(named: "chart")!.cgColor
        
        let bar = NSTitlebarAccessoryViewController()
        bar.view = Title()
        bar.layoutAttribute = .bottom
        addTitlebarAccessoryViewController(bar)
        
        var chart: Chart?
        subscription = cloud
            .archive
            .map(\.plotter)
            .removeDuplicates()
            .sink { [weak self] in
                guard let layer = self?.contentView?.layer else { return }
                chart?.removeFromSuperlayer()
                chart = .init(frame: layer.bounds.insetBy(dx: 40, dy: 40), values: $0)
                layer.addSublayer(chart!)
            }
    }
}
