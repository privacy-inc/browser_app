import AppKit
import Combine

extension New {
    final class History: Collection<New.History.Cell> {
        private static let insets = CGFloat(4)
        private static let insets2 = insets + insets
        
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
                .map {
                    $0 - Self.insets2
                }
                .removeDuplicates()
                .subscribe(width)
                .store(in: &subs)
            
            cloud
                .archive
                .map(\.browse)
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
                                    if !browse.page.access.domain.isEmpty {
                                        $0.append(.make(browse.page.access.domain,
                                                        font: .preferredFont(forTextStyle: .callout),
                                                        color: .secondaryLabelColor))
                                        $0.linebreak()
                                    }
                                    $0.append(.make(RelativeDateTimeFormatter().string(from: browse.date),
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
                            $0.y += height + Self.insets
                        }
                    self?.items.send(result.items)
                    self?.height.send(result.y)
                }
                .store(in: &subs)
            
            selected
                .sink {
                    cloud.revisit($0)
                    tabber.browse(id, $0)
                }
                .store(in: &subs)
        }
        
        override var allowsVibrancy: Bool {
            true
        }
        
        override func delete() {
            highlighted
                .value
                .map(cloud.remove(browse:))
        }
    }
}
