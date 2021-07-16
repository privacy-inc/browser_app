import AppKit
import Combine

extension New {
    final class History: Collection<Cell, Info> {
        required init?(coder: NSCoder) { nil }
        init(session: Session, id: UUID) {
            super.init()
            translatesAutoresizingMaskIntoConstraints = false
            
            let width = PassthroughSubject<CGFloat, Never>()
            let info = PassthroughSubject<[Info], Never>()
            
            NotificationCenter
                .default
                .publisher(for: NSView.frameDidChangeNotification, object: contentView)
                .compactMap {
                    ($0.object as? NSView)?.bounds.width
                }
                .map {
                    $0 - New.insets2
                }
                .removeDuplicates()
                .subscribe(width)
                .store(in: &subs)
            
            cloud
                .archive
                .map(\.browses)
                .removeDuplicates()
                .map {
                    $0
                        .map { browse in
                            .init(
                                id: browse.id,
                                string: .make {
                                    if !browse.page.title.isEmpty {
                                        $0.append(.make(browse.page.title,
                                                        font: .preferredFont(forTextStyle: .body),
                                                        color: .labelColor))
                                        $0.linebreak()
                                    }
                                    $0.append(.make(browse.page.access.short + " - " + RelativeDateTimeFormatter().string(from: browse.date),
                                                    font: .preferredFont(forTextStyle: .callout),
                                                    color: .secondaryLabelColor))
                                })
                        }
                }
                .subscribe(info)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .combineLatest(width
                                .removeDuplicates())
                .sink { [weak self] (info: [Info], width: CGFloat) in
                    let result = info
                        .reduce(into: (items: Set<CollectionItem<Info>>(), y: New.insets_2)) {
                            let height = ceil($1.string.height(for: width - Cell.insets2) + Cell.insets2)
                            $0.items.insert(.init(
                                                info: $1,
                                                rect: .init(
                                                    x: New.insets,
                                                    y: $0.y,
                                                    width: width,
                                                    height: height)))
                            $0.y += height + 2
                        }
                    self?.first.send(info.first?.id)
                    self?.items.send(result.items)
                    self?.height.send(result.y + New.insets_2)
                }
                .store(in: &subs)
            
            selected
                .compactMap {
                    $0
                }
                .sink {
                    cloud.revisit($0)
                    session.tab.browse(id, $0)
                }
                .store(in: &subs)
        }
        
        override func delete() {
            highlighted
                .value
                .map(cloud.remove(browse:))
        }
    }
}
