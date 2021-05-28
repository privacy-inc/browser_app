import AppKit
import Combine
import Sleuth

extension New {
    final class Bookmarks: Collection<New.Bookmarks.Cell> {
        private static let padding = CGFloat(4)
        private static let insets = CGFloat(6)
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            super.init()
            translatesAutoresizingMaskIntoConstraints = false
            
            let width = PassthroughSubject<CGFloat, Never>()
            let info = PassthroughSubject<[CollectionItemInfo], Never>()
            
            NotificationCenter
                .default
                .publisher(for: NSView.frameDidChangeNotification, object: contentView)
                .compactMap {
                    ($0.object as? NSView)?.bounds.width
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
                                        $0.add(page.title,
                                               font: .preferredFont(forTextStyle: .body),
                                               color: .labelColor)
                                    }
                                    if !page.access.domain.isEmpty {
                                        if !page.title.isEmpty {
                                            $0.linebreak()
                                        }
                                        $0.add(page.access.domain,
                                               font: .preferredFont(forTextStyle: .callout),
                                               color: .secondaryLabelColor)
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
                .sink { [weak self] (info: [CollectionItemInfo], width: CGFloat) in
                    let result = info
                        .reduce(into: (items: Set<CollectionItem>(), y: Self.insets)) {
                            let height = ceil($1.string.height(for: width - Cell.insets2) + Cell.insets2)
                            $0.items.insert(.init(
                                                info: $1,
                                                rect: .init(
                                                    x: Self.insets,
                                                    y: $0.y,
                                                    width: width,
                                                    height: height)))
                            $0.y += height + Self.padding
                        }
                    self?.items.send(result.items)
                    self?.height.send(result.y + Self.insets)
                }
                .store(in: &subs)
        }
    }
}
