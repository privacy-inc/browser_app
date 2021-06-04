import AppKit
import Combine

final class Trackers: NSWindow {
    private var subscription: AnyCancellable?
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 460, height: 300),
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        setFrameAutosaveName("Trackers")
        title = NSLocalizedString("Trackers", comment: "")
        center()
        
        let bar = NSTitlebarAccessoryViewController()
        bar.view = Title()
        bar.layoutAttribute = .top
        addTitlebarAccessoryViewController(bar)
        
        let scroll = Scroll()
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.right.constraint(equalTo: scroll.rightAnchor).isActive = true
        contentView = scroll
        
        subscription = cloud
            .archive
            .map(\.trackers)
            .removeDuplicates {
                $0.flatMap(\.count) == $1.flatMap(\.count)
            }
            .sink { trackers in
                scroll
                    .views
                    .forEach {
                        $0.removeFromSuperview()
                    }
                
                guard !trackers.isEmpty else { return }
                
                var top = scroll.top
                trackers
                    .map {
                        Item.init(name: $0.name, count: $0.count)
                    }
                    .forEach {
                        scroll.add($0)
                        
                        $0.leftAnchor.constraint(equalTo: scroll.left, constant: 20).isActive = true
                        $0.rightAnchor.constraint(equalTo: scroll.right, constant: -20).isActive = true
                        
                        if top != scroll.top {
                            let separator = NSView()
                            separator.translatesAutoresizingMaskIntoConstraints = false
                            separator.wantsLayer = true
                            separator.layer!.backgroundColor = NSColor.separatorColor.cgColor
                            
                            scroll.add(separator)
                            
                            separator.topAnchor.constraint(equalTo: top).isActive = true
                            separator.leftAnchor.constraint(equalTo: scroll.left, constant: 20).isActive = true
                            separator.rightAnchor.constraint(equalTo: scroll.right, constant: -20).isActive = true
                            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                            $0.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
                        } else {
                            $0.topAnchor.constraint(equalTo: top, constant: 10).isActive = true
                        }
                        
                        top = $0.bottomAnchor
                    }
                
                scroll.bottom.constraint(equalTo: top, constant: 10).isActive = true
            }
    }
}
