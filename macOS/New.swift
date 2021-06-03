import AppKit
import Combine

final class New: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
        super.init(frame: .zero)
        
        let content = NSView()
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content)
        
        let titleBookmarks = Text()
        titleBookmarks.stringValue = NSLocalizedString("Bookmarks", comment: "")
        titleBookmarks.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold)
        titleBookmarks.textColor = .secondaryLabelColor
        content.addSubview(titleBookmarks)
        
        let titleHistory = Text()
        titleHistory.stringValue = NSLocalizedString("Recent", comment: "")
        titleHistory.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold)
        titleHistory.textColor = .secondaryLabelColor
        content.addSubview(titleHistory)
        
        let backgroundBookmarks = NSView()
        backgroundBookmarks.translatesAutoresizingMaskIntoConstraints = false
        backgroundBookmarks.wantsLayer = true
        backgroundBookmarks.layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.3).cgColor
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
        
        content.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        content.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        content.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        content.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        titleBookmarks.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        titleBookmarks.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        
        titleHistory.bottomAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
        titleHistory.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        
        bookmarks.topAnchor.constraint(equalTo: backgroundBookmarks.topAnchor, constant: 1).isActive = true
        bookmarks.bottomAnchor.constraint(equalTo: backgroundBookmarks.bottomAnchor, constant: -1).isActive = true
        bookmarks.leftAnchor.constraint(equalTo: backgroundBookmarks.leftAnchor, constant: 1).isActive = true
        bookmarks.rightAnchor.constraint(equalTo: backgroundBookmarks.rightAnchor, constant: -1).isActive = true
        
        backgroundBookmarks.topAnchor.constraint(equalTo: titleBookmarks.bottomAnchor, constant: 10).isActive = true
        backgroundBookmarks.bottomAnchor.constraint(equalTo: titleHistory.topAnchor, constant: -30).isActive = true
        backgroundBookmarks.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        backgroundBookmarks.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        
        backgroundHistory.topAnchor.constraint(equalTo: titleHistory.bottomAnchor, constant: 10).isActive = true
        backgroundHistory.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        backgroundHistory.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        backgroundHistory.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        
        history.topAnchor.constraint(equalTo: backgroundHistory.topAnchor, constant: 1).isActive = true
        history.bottomAnchor.constraint(equalTo: backgroundHistory.bottomAnchor, constant: -1).isActive = true
        history.leftAnchor.constraint(equalTo: backgroundHistory.leftAnchor, constant: 1).isActive = true
        history.rightAnchor.constraint(equalTo: backgroundHistory.rightAnchor, constant: -1).isActive = true
        
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
        window?.makeFirstResponder(self)
    }
}
