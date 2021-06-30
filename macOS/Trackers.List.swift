import AppKit
import Combine
import Sleuth

extension Trackers {
    final class List: Collection<New.Cell, New.Info> {
        static let width = CGFloat(220)
        static let insets2 = insets + insets
        private static let insets = CGFloat(10)
        
        required init?(coder: NSCoder) { nil }
        init(sorted: CurrentValueSubject<Sleuth.Trackers, Never>) {
            super.init()
            translatesAutoresizingMaskIntoConstraints = false
            
            let info = PassthroughSubject<[New.Info], Never>()
            
            cloud
                .archive
                .combineLatest(sorted
                                .removeDuplicates())
                .map {
                    $0.0.trackers($0.1)
                }
                .removeDuplicates {
                    $0.flatMap(\.count) == $1.flatMap(\.count)
                }
                .map {
                    $0
                        .enumerated()
                        .map { (index: Int, blocked: (String, [Date])) in
                            .init(
                                id: index,
                                string: .make {
                                    $0.append(.make(blocked.0,
                                                    font: .preferredFont(forTextStyle: .body),
                                                    color: .labelColor))
                                })
                        }
                }
                .subscribe(info)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .sink { [weak self] in
                    let result = $0
                        .reduce(into: (items: Set<CollectionItem<New.Info>>(), y: Self.insets)) {
                            let height = ceil($1.string.height(for: Self.width - New.Cell.insets2) + New.Cell.insets2)
                            $0.items.insert(.init(
                                                info: $1,
                                                rect: .init(
                                                    x: Self.insets,
                                                    y: $0.y,
                                                    width: Self.width,
                                                    height: height)))
                            $0.y += height
                        }
                    self?.first.send($0.first?.id)
                    self?.items.send(result.items)
                    self?.height.send(result.y)
                }
                .store(in: &subs)
            
            selected
                .sink {
                    cloud.revisit($0)
//                    tabber.browse(id, $0)
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
