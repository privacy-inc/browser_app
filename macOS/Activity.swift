import AppKit
import Combine

final class Activity: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 560, height: 300),
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        title = NSLocalizedString("Activity", comment: "")
        contentView = NSVisualEffectView()
        center()
        setFrameAutosaveName("Activity")
        
        let since = Text()
        since.font = .preferredFont(forTextStyle: .callout)
        since.textColor = .secondaryLabelColor
        contentView!.addSubview(since)
        
        let now = Text()
        now.font = .preferredFont(forTextStyle: .callout)
        now.textColor = .secondaryLabelColor
        now.stringValue = NSLocalizedString("Now", comment: "")
        contentView!.addSubview(now)
        
        let viewer = NSView()
        viewer.translatesAutoresizingMaskIntoConstraints = false
        viewer.wantsLayer = true
        contentView!.addSubview(viewer)
        
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
            .map {
                RelativeDateTimeFormatter().string(from: $0)
            }
            .removeDuplicates()
            .sink {
                since.stringValue = $0
            }
            .store(in: &subs)
        
        cloud
            .archive
            .map(\.plotter)
            .removeDuplicates()
            .sink {
                viewer
                    .layer!
                    .sublayers
                    .map {
                        $0.forEach {
                            $0.removeFromSuperlayer()
                        }
                    }
                
                viewer.layer!.addSublayer(Chart(frame: viewer.layer!.bounds.insetBy(dx: 40, dy: 40), values: $0))
            }
            .store(in: &subs)
    }
}
