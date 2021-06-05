import AppKit
import Combine

final class New: NSView {
    private var subs = Set<AnyCancellable>()
    
    deinit {
        print("gone new")
    }
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
        super.init(frame: .zero)
        
        let content = NSView()
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content)
        
        let titleBookmarks = Text()
        titleBookmarks.stringValue = NSLocalizedString("Bookmarks", comment: "")
        titleBookmarks.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold)
        titleBookmarks.textColor = .controlAccentColor
        content.addSubview(titleBookmarks)
        
        let titleHistory = Text()
        titleHistory.stringValue = NSLocalizedString("Recent", comment: "")
        titleHistory.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold)
        titleHistory.textColor = .controlAccentColor
        content.addSubview(titleHistory)
        
        let backgroundBookmarks = NSView()
        backgroundBookmarks.translatesAutoresizingMaskIntoConstraints = false
        backgroundBookmarks.wantsLayer = true
        backgroundBookmarks.layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.1).cgColor
        backgroundBookmarks.layer!.cornerRadius = 6
        backgroundBookmarks.layer!.borderWidth = 1
        backgroundBookmarks.layer!.borderColor = NSColor.controlAccentColor.cgColor
        content.addSubview(backgroundBookmarks)
        
        let backgroundHistory = NSView()
        backgroundHistory.translatesAutoresizingMaskIntoConstraints = false
        backgroundHistory.wantsLayer = true
        backgroundHistory.layer!.backgroundColor = backgroundBookmarks.layer!.backgroundColor
        backgroundHistory.layer!.cornerRadius = backgroundBookmarks.layer!.cornerRadius
        backgroundHistory.layer!.borderWidth = backgroundBookmarks.layer!.borderWidth
        backgroundHistory.layer!.borderColor = backgroundBookmarks.layer!.borderColor
        content.addSubview(backgroundHistory)
        
        let bookmarks = Bookmarks(id: id)
        content.addSubview(bookmarks)
        
        let history = History(id: id)
        backgroundHistory.addSubview(history)
         
        let activity = Option(icon: "chart.bar.xaxis")
        activity
            .click
            .sink {
                NSApp.activity()
            }
            .store(in: &subs)
        addSubview(activity)
        
        let trackers = Option(icon: "shield.lefthalf.fill")
        trackers
            .click
            .sink {
                NSApp.trackers()
            }
            .store(in: &subs)
        addSubview(trackers)
        
        content.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.3).isActive = true
        content.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.7).isActive = true
        content.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        content.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        titleBookmarks.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        titleBookmarks.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        
        titleHistory.bottomAnchor.constraint(equalTo: backgroundHistory.topAnchor, constant: -5).isActive = true
        titleHistory.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        
        backgroundBookmarks.topAnchor.constraint(equalTo: titleBookmarks.bottomAnchor, constant: 5).isActive = true
        backgroundBookmarks.heightAnchor.constraint(equalTo: content.heightAnchor, multiplier: 0.2).isActive = true
        backgroundBookmarks.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        backgroundBookmarks.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        
        backgroundHistory.heightAnchor.constraint(equalTo: content.heightAnchor, multiplier: 0.4).isActive = true
        backgroundHistory.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        backgroundHistory.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        backgroundHistory.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        
        bookmarks.topAnchor.constraint(equalTo: backgroundBookmarks.topAnchor, constant: 1).isActive = true
        bookmarks.bottomAnchor.constraint(equalTo: backgroundBookmarks.bottomAnchor, constant: -1).isActive = true
        bookmarks.leftAnchor.constraint(equalTo: backgroundBookmarks.leftAnchor, constant: 1).isActive = true
        bookmarks.rightAnchor.constraint(equalTo: backgroundBookmarks.rightAnchor, constant: -1).isActive = true
        
        history.topAnchor.constraint(equalTo: backgroundHistory.topAnchor, constant: 1).isActive = true
        history.bottomAnchor.constraint(equalTo: backgroundHistory.bottomAnchor, constant: -1).isActive = true
        history.leftAnchor.constraint(equalTo: backgroundHistory.leftAnchor, constant: 1).isActive = true
        history.rightAnchor.constraint(equalTo: backgroundHistory.rightAnchor, constant: -1).isActive = true
        
        trackers.bottomAnchor.constraint(equalTo: activity.topAnchor, constant: -10).isActive = true
        trackers.rightAnchor.constraint(equalTo: activity.rightAnchor).isActive = true
        
        activity.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        activity.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        cloud
            .archive
            .map {
                $0.bookmarks.isEmpty
            }
            .removeDuplicates()
            .sink {
                titleBookmarks.isHidden = $0
                backgroundBookmarks.isHidden = $0
                bookmarks.isHidden = $0
            }
            .store(in: &subs)
        
        cloud
            .archive
            .map {
                $0.browse.isEmpty
            }
            .removeDuplicates()
            .sink {
                titleHistory.isHidden = $0
                backgroundHistory.isHidden = $0
                history.isHidden = $0
            }
            .store(in: &subs)
    }
    
    override func mouseDown(with: NSEvent) {
        super.mouseDown(with: with)
        if with.clickCount == 1 {
            window?.makeFirstResponder(self)
        }
    }
}
