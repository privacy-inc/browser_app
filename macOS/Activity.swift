import AppKit
import Combine

final class Activity: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 560, height: 400),
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        title = NSLocalizedString("Activity", comment: "")
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .popover
        contentView = content
        center()
        setFrameAutosaveName("Activity")
        
        cloud
            .archive
            .map(\.activity)
            .removeDuplicates()
            .sink {
                content
                    .subviews
                    .forEach {
                        $0.removeFromSuperview()
                    }
                content.addSubview(Chart(frame: content.bounds, first: $0.first ?? .init(), values: $0.plotter))
            }
            .store(in: &subs)
    }
}
