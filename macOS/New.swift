import AppKit
import Combine

final class New: NSView {
    static let insets_2 = CGFloat(10)
    static let insets = insets_2 + insets_2
    static let insets2 = insets + insets
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        registerForDraggedTypes([.fileURL])
        
        let backgroundBookmarks = NSVisualEffectView()
        backgroundBookmarks.state = .active
        backgroundBookmarks.isEmphasized = true
        backgroundBookmarks.material = .popover
        backgroundBookmarks.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundBookmarks)
        
        let separatorBookmarks = Separator(mode: .vertical)
        backgroundBookmarks.addSubview(separatorBookmarks)
        
        let backgroundHistory = NSVisualEffectView()
        backgroundHistory.material = .hudWindow
        backgroundHistory.state = .active
        backgroundHistory.isEmphasized = true
        backgroundHistory.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundHistory)
        
        let backgroundOptions = NSVisualEffectView()
        backgroundOptions.material = .popover
        backgroundOptions.state = .active
        backgroundOptions.isEmphasized = true
        backgroundOptions.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundOptions)
        
        let separatorOptions = Separator(mode: .vertical)
        backgroundOptions.addSubview(separatorOptions)
        
        let bookmarks = Bookmarks(id: id)
        backgroundBookmarks.addSubview(bookmarks)
        
        let history = History(id: id)
        backgroundHistory.addSubview(history)
         
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
        
        backgroundBookmarks.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundBookmarks.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundBookmarks.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backgroundBookmarks.widthAnchor.constraint(greaterThanOrEqualToConstant: 140).isActive = true
        backgroundBookmarks.widthAnchor.constraint(lessThanOrEqualToConstant: 280).isActive = true
        backgroundBookmarks.widthAnchor.constraint(lessThanOrEqualTo: backgroundHistory.widthAnchor).isActive = true
        
        separatorBookmarks.rightAnchor.constraint(equalTo: backgroundBookmarks.rightAnchor).isActive = true
        separatorBookmarks.topAnchor.constraint(equalTo: backgroundBookmarks.topAnchor).isActive = true
        separatorBookmarks.bottomAnchor.constraint(equalTo: backgroundBookmarks.bottomAnchor).isActive = true
        
        backgroundHistory.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundHistory.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundHistory.leftAnchor.constraint(equalTo: backgroundBookmarks.rightAnchor).isActive = true
        backgroundHistory.rightAnchor.constraint(equalTo: backgroundOptions.leftAnchor).isActive = true
        backgroundHistory.widthAnchor.constraint(greaterThanOrEqualToConstant: 140).isActive = true
        
        backgroundOptions.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundOptions.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundOptions.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        backgroundOptions.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        separatorOptions.leftAnchor.constraint(equalTo: backgroundOptions.leftAnchor).isActive = true
        separatorOptions.topAnchor.constraint(equalTo: backgroundOptions.topAnchor).isActive = true
        separatorOptions.bottomAnchor.constraint(equalTo: backgroundOptions.bottomAnchor).isActive = true
        
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
                backgroundOptions.addSubview($0)
                $0.bottomAnchor.constraint(equalTo: bottom, constant: bottom == bottomAnchor ? -20 : -10).isActive = true
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
