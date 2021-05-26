import AppKit

final class New: NSView {
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
        
        let titleRecent = Text()
        titleRecent.stringValue = NSLocalizedString("Recent", comment: "")
        titleRecent.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold)
        titleRecent.textColor = .secondaryLabelColor
        content.addSubview(titleRecent)
        
        let bookmarks = Bookmarks(id: id)
        content.addSubview(bookmarks)
        
        let history = History(id: id)
        content.addSubview(history)
        
        content.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        content.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        content.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        content.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        titleBookmarks.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        titleBookmarks.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        
        titleRecent.topAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
        titleRecent.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        
        bookmarks.topAnchor.constraint(equalTo: titleBookmarks.bottomAnchor, constant: 10).isActive = true
        bookmarks.bottomAnchor.constraint(equalTo: content.centerYAnchor, constant: -30).isActive = true
        bookmarks.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        bookmarks.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        
        history.topAnchor.constraint(equalTo: titleRecent.bottomAnchor, constant: 10).isActive = true
        history.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -30).isActive = true
        history.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        history.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
    }
}
