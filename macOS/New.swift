import AppKit
import Combine

final class New: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
        super.init(frame: .zero)
        
        let backgroundBookmarks = NSVisualEffectView()
        backgroundBookmarks.material = .menu
        backgroundBookmarks.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundBookmarks)
        
        let backgroundHistory = NSVisualEffectView()
        backgroundHistory.material = .sidebar
        backgroundHistory.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundHistory)
        
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
        backgroundBookmarks.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        let bookmarksWidth = backgroundBookmarks.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.1)
        bookmarksWidth.priority = .defaultLow
        bookmarksWidth.isActive = true
        
        backgroundHistory.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundHistory.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundHistory.leftAnchor.constraint(equalTo: backgroundBookmarks.rightAnchor).isActive = true
        backgroundHistory.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        let historyWidth = backgroundHistory.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.2)
        historyWidth.priority = .defaultLow
        historyWidth.isActive = true
        
        bookmarks.topAnchor.constraint(equalTo: backgroundBookmarks.topAnchor).isActive = true
        bookmarks.bottomAnchor.constraint(equalTo: backgroundBookmarks.bottomAnchor).isActive = true
        bookmarks.leftAnchor.constraint(equalTo: backgroundBookmarks.leftAnchor).isActive = true
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
}
