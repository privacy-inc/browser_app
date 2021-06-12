import AppKit
import Combine

final class New: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
        super.init(frame: .zero)
        
        let titleBookmarks = Text()
        titleBookmarks.stringValue = NSLocalizedString("Bookmarks", comment: "")
        titleBookmarks.font = .font(style: .title3, weight: .bold)
        titleBookmarks.textColor = .controlAccentColor
        addSubview(titleBookmarks)
        
        let titleHistory = Text()
        titleHistory.stringValue = NSLocalizedString("Recent", comment: "")
        titleHistory.font = titleBookmarks.font!
        titleHistory.textColor = .controlAccentColor
        addSubview(titleHistory)
        
        let backgroundBookmarks = NSView()
        backgroundBookmarks.translatesAutoresizingMaskIntoConstraints = false
        backgroundBookmarks.wantsLayer = true
        backgroundBookmarks.layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.1).cgColor
        backgroundBookmarks.layer!.cornerRadius = 6
        backgroundBookmarks.layer!.borderWidth = 1
        backgroundBookmarks.layer!.borderColor = NSColor.controlAccentColor.cgColor
        addSubview(backgroundBookmarks)
        
        let backgroundHistory = NSView()
        backgroundHistory.translatesAutoresizingMaskIntoConstraints = false
        backgroundHistory.wantsLayer = true
        backgroundHistory.layer!.backgroundColor = backgroundBookmarks.layer!.backgroundColor
        backgroundHistory.layer!.cornerRadius = backgroundBookmarks.layer!.cornerRadius
        backgroundHistory.layer!.borderWidth = backgroundBookmarks.layer!.borderWidth
        backgroundHistory.layer!.borderColor = backgroundBookmarks.layer!.borderColor
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
                NSApp.trackers()
            }
            .store(in: &subs)
        
        titleBookmarks.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        titleBookmarks.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
        backgroundBookmarks.topAnchor.constraint(equalTo: titleBookmarks.bottomAnchor, constant: 5).isActive = true
        backgroundBookmarks.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.2).isActive = true
        backgroundBookmarks.leftAnchor.constraint(equalTo: titleBookmarks.leftAnchor).isActive = true
        backgroundBookmarks.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        
        titleHistory.topAnchor.constraint(equalTo: backgroundBookmarks.bottomAnchor, constant: 30).isActive = true
        titleHistory.leftAnchor.constraint(equalTo: titleBookmarks.leftAnchor).isActive = true
        
        backgroundHistory.topAnchor.constraint(equalTo: titleHistory.bottomAnchor, constant: 5).isActive = true
        backgroundHistory.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        backgroundHistory.leftAnchor.constraint(equalTo: titleHistory.leftAnchor).isActive = true
        backgroundHistory.widthAnchor.constraint(equalTo: backgroundBookmarks.widthAnchor).isActive = true
        
        bookmarks.topAnchor.constraint(equalTo: backgroundBookmarks.topAnchor, constant: 1).isActive = true
        bookmarks.bottomAnchor.constraint(equalTo: backgroundBookmarks.bottomAnchor, constant: -1).isActive = true
        bookmarks.leftAnchor.constraint(equalTo: backgroundBookmarks.leftAnchor, constant: 1).isActive = true
        bookmarks.rightAnchor.constraint(equalTo: backgroundBookmarks.rightAnchor, constant: -1).isActive = true
        
        history.topAnchor.constraint(equalTo: backgroundHistory.topAnchor, constant: 1).isActive = true
        history.bottomAnchor.constraint(equalTo: backgroundHistory.bottomAnchor, constant: -1).isActive = true
        history.leftAnchor.constraint(equalTo: backgroundHistory.leftAnchor, constant: 1).isActive = true
        history.rightAnchor.constraint(equalTo: backgroundHistory.rightAnchor, constant: -1).isActive = true
        
        var bottom = bottomAnchor
        [activity, trackers, forget]
            .forEach {
                addSubview($0)
                $0.bottomAnchor.constraint(equalTo: bottom, constant: bottom == bottomAnchor ? -16 : -10).isActive = true
                $0.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
                bottom = $0.topAnchor
            }
        
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
