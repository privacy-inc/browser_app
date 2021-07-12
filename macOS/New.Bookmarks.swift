import AppKit
import Combine
import Sleuth

extension New {
    final class Bookmarks: Collection<Cell, Info> {
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
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
                .map(\.bookmarks)
                .removeDuplicates()
                .map {
                    $0
                        .enumerated()
                        .map { (index: Int, page: Page) in
                            .init(
                                id: index,
                                string: .make {
                                    if !page.title.isEmpty {
                                        $0.append(.make(page.title,
                                                        font: .preferredFont(forTextStyle: .body),
                                                        color: .labelColor))
                                    }
                                    if !page.access.short.isEmpty {
                                        if !page.title.isEmpty {
                                            $0.linebreak()
                                        }
                                        $0.append(.make(page.access.short,
                                                        font: .preferredFont(forTextStyle: .callout),
                                                        color: .secondaryLabelColor))
                                    }
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
                    cloud
                        .open($0) {
                            tabber.browse(id, $0)
                        }
                }
                .store(in: &subs)
        }
        
        override func delete() {
            highlighted
                .value
                .map(cloud.remove(bookmark:))
        }
    }
}
