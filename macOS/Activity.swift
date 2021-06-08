import AppKit
import Combine

final class Activity: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 560, height: 300),
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        setFrameAutosaveName("Activity")
        titlebarAppearsTransparent = true
        title = NSLocalizedString("Activity", comment: "")
        center()
        contentView = NSVisualEffectView()
        
        let since = Text()
        since.font = .preferredFont(forTextStyle: .callout)
        since.textColor = .secondaryLabelColor
        contentView!.addSubview(since)
        
        let now = Text()
        now.font = .preferredFont(forTextStyle: .callout)
        now.textColor = .secondaryLabelColor
        now.stringValue = NSLocalizedString("Now", comment: "")
        contentView!.addSubview(now)
        
        let viewer = Viewer()
        contentView!.addSubview(viewer)
        
        var chart: Chart?
        
        since.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -20).isActive = true
        since.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 30).isActive = true
        
        now.bottomAnchor.constraint(equalTo: since.bottomAnchor).isActive = true
        now.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -30).isActive = true
        
        viewer.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        viewer.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        viewer.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        viewer.bottomAnchor.constraint(equalTo: since.topAnchor, constant: -20).isActive = true
        
        contentView!.layoutSubtreeIfNeeded()
        
        cloud
            .archive
            .compactMap(\.since)
            .removeDuplicates()
            .sink {
                since.stringValue = RelativeDateTimeFormatter().string(from: $0)
            }
            .store(in: &subs)
        
        cloud
            .archive
            .map(\.plotter)
            .removeDuplicates()
            .sink { [weak self] in
                chart?.removeFromSuperlayer()
                chart = .init(frame: viewer.layer!.bounds.insetBy(dx: 40, dy: 40), values: $0)
                viewer.layer!.addSublayer(chart!)
            }
            .store(in: &subs)
    }
}
