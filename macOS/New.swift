import AppKit
import Combine

final class New: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
        super.init(frame: .zero)
        registerForDraggedTypes([.fileURL])
        
        let backgroundBookmarks = NSVisualEffectView()
        backgroundBookmarks.material = .sidebar
        backgroundBookmarks.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundBookmarks)
        
        let backgroundHistory = NSVisualEffectView()
        backgroundHistory.material = .menu
        backgroundHistory.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundHistory)
        
        let backgroundOptions = NSVisualEffectView()
        backgroundOptions.material = .sidebar
        backgroundOptions.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundOptions)
        
        let bookmarks = Bookmarks(id: id)
        addSubview(bookmarks)
        
        let history = History(id: id)
        addSubview(history)
         
        let activity = Option(icon: "chart.bar.xaxis")
        activity
            .click
            .sink {
                NSApp.activity()
            }
            .store(in: &subs)
        
        let trackers = Option(icon: "shield.lefthalf.fill")
        trackers
            .click
            .sink {
                NSApp.trackers()
            }
            .store(in: &subs)
        
        let forget = Option(icon: "flame.fill")
        forget
            .click
            .sink {
                Forget()
                    .show(relativeTo: forget.bounds, of: forget, preferredEdge: .maxX)
            }
            .store(in: &subs)
        
        backgroundBookmarks.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundBookmarks.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundBookmarks.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backgroundBookmarks.widthAnchor.constraint(greaterThanOrEqualToConstant: 140).isActive = true
        backgroundBookmarks.widthAnchor.constraint(lessThanOrEqualToConstant: 280).isActive = true
        backgroundBookmarks.widthAnchor.constraint(lessThanOrEqualTo: backgroundHistory.widthAnchor).isActive = true
        
        backgroundHistory.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundHistory.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundHistory.leftAnchor.constraint(equalTo: backgroundBookmarks.rightAnchor).isActive = true
        backgroundHistory.rightAnchor.constraint(equalTo: backgroundOptions.leftAnchor).isActive = true
        backgroundHistory.widthAnchor.constraint(greaterThanOrEqualToConstant: 140).isActive = true
        
        backgroundOptions.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundOptions.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundOptions.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        backgroundOptions.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        bookmarks.topAnchor.constraint(equalTo: backgroundBookmarks.topAnchor).isActive = true
        bookmarks.bottomAnchor.constraint(equalTo: backgroundBookmarks.bottomAnchor).isActive = true
        bookmarks.leftAnchor.constraint(equalTo: backgroundBookmarks.leftAnchor, constant: 10).isActive = true
        bookmarks.rightAnchor.constraint(equalTo: backgroundBookmarks.rightAnchor).isActive = true
        
        history.topAnchor.constraint(equalTo: backgroundHistory.topAnchor).isActive = true
        history.bottomAnchor.constraint(equalTo: backgroundHistory.bottomAnchor).isActive = true
        history.leftAnchor.constraint(equalTo: backgroundHistory.leftAnchor).isActive = true
        history.rightAnchor.constraint(equalTo: backgroundHistory.rightAnchor).isActive = true
        
        var bottom = bottomAnchor
        [activity, trackers, forget]
            .forEach {
                addSubview($0)
                $0.bottomAnchor.constraint(equalTo: bottom, constant: bottom == bottomAnchor ? -16 : -10).isActive = true
                $0.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
                bottom = $0.topAnchor
            }
    }
    
    override func mouseDown(with: NSEvent) {
        super.mouseDown(with: with)
        if with.clickCount == 1 {
            window?.makeFirstResponder(self)
        }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        NSCursor.dragCopy.set()
        return super.draggingEntered(sender)
    }
    
    override func draggingExited(_: NSDraggingInfo?) {
        NSCursor.arrow.set()
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        if frame.contains(sender.draggingLocation) {
            sender
                .draggingPasteboard
                .propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType"))
                .flatMap {
                    $0 as? NSArray
                }
                .flatMap {
                    $0.count > 0 ? $0[0] as? String : nil
                }
                .map(URL.init(fileURLWithPath:))
                .map {
                    NSApp.open(tab: $0, change: false)
                }
        }
    }
}
