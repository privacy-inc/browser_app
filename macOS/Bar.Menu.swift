import AppKit
import Combine

extension Bar {
    final class Menu: NSPopover {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(session: Session, id: UUID, origin: NSView) {
            super.init()
            behavior = .semitransient
            contentSize = .init(width: 80, height: 110)
            contentViewController = .init()
            contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
            
            let clockwise = Item(image: "arrow.clockwise")
            clockwise.toolTip = NSLocalizedString("Reload", comment: "")
            clockwise
                .click
                .sink {
                    session
                        .reload
                        .send(id)
                }
                .store(in: &subs)
            
            let nosign = Item(image: "nosign")
            nosign.toolTip = NSLocalizedString("Stop", comment: "")
            nosign
                .click
                .sink {
                    session
                        .stop
                        .send(id)
                }
                .store(in: &subs)
            
            let info = Item(image: "info.circle")
            info.toolTip = NSLocalizedString("Info", comment: "")
            info
                .click
                .sink {
                    Info(session: session, id: id)
                        .show(relativeTo: origin.bounds, of: origin, preferredEdge: .minY)
                }
                .store(in: &subs)
            
            let share = Item(image: "square.and.arrow.up")
            share.toolTip = NSLocalizedString("Share", comment: "")
            share
                .click
                .sink {
                    Share(session: session, id: id)
                        .show(relativeTo: origin.bounds, of: origin, preferredEdge: .minY)
                }
                .store(in: &subs)
            
            let bookmark = Item(image: "bookmark")
            bookmark.toolTip = NSLocalizedString("Bookmark", comment: "")
            bookmark
                .click
                .sink { [weak self] in
                    self?.close()
                    
                    session
                        .tab
                        .items
                        .value[state: id]
                        .browse
                        .map(cloud.bookmark)
                    Toast.show(message: .init(title: "Bookmark added", icon: "bookmark.fill"))
                }
                .store(in: &subs)
            
            let xmark = Item(image: "xmark")
            xmark.toolTip = NSLocalizedString("Close", comment: "")
            xmark
                .click
                .sink { [weak self] in
                    self?.close()
                    session
                        .close
                        .send(id)
                }
                .store(in: &subs)
            
            session
                .tab
                .items
                .map {
                    (isBrowse: $0[state: id].isBrowse, loading: $0[loading: id])
                }
                .removeDuplicates {
                    $0.isBrowse == $1.isBrowse
                        && $0.loading == $1.loading
                }
                .sink {
                    clockwise.state = $0.isBrowse && !$0.loading ? .on : .off
                    nosign.state = $0.isBrowse && $0.loading ? .on : .off
                }
                .store(in: &subs)
            
            var top = contentViewController!.view
            [nosign, share, info]
                .forEach {
                    contentViewController!.view.addSubview($0)
                    $0.rightAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor, constant: -2).isActive = true
                    $0.topAnchor.constraint(equalTo: top == contentViewController!.view ? top.topAnchor : top.bottomAnchor, constant:
                                                top == contentViewController!.view
                                                ? 12
                                                : 4).isActive = true
                    top = $0
                }
            
            top = contentViewController!.view
            [clockwise, bookmark, xmark]
                .forEach {
                    contentViewController!.view.addSubview($0)
                    $0.leftAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor, constant: 2).isActive = true
                    $0.topAnchor.constraint(equalTo: top == contentViewController!.view ? top.topAnchor : top.bottomAnchor, constant:
                                                top == contentViewController!.view
                                                ? 12
                                                : 4).isActive = true
                    top = $0
                }
        }
    }
}
