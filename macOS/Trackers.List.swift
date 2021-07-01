import Foundation
import Combine
import Sleuth

extension Trackers {
    final class List: Collection<Cell, Info> {
        static let width = CGFloat(240)
        static let insets2 = insets + insets
        private static let insets = CGFloat(10)
        
        required init?(coder: NSCoder) { nil }
        init(sorted: CurrentValueSubject<Sleuth.Trackers, Never>, show: PassthroughSubject<[Date]?, Never>) {
            super.init()
            translatesAutoresizingMaskIntoConstraints = false
            
            let info = CurrentValueSubject<[Info], Never>([])
            
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
                                title: .make {
                                    $0.append(.make(blocked.0,
                                                    font: .preferredFont(forTextStyle: .body),
                                                    color: .labelColor))
                                    $0.linebreak()
                                    $0.append(.make(blocked
                                                        .1
                                                        .last
                                                        .map {
                                                            RelativeDateTimeFormatter().string(from: $0)
                                                        }
                                                        ?? "",
                                                        font: .preferredFont(forTextStyle: .callout),
                                                        color: .secondaryLabelColor))
                                },
                                counter: .make {
                                    $0.append(.make(session.decimal.string(from: .init(value: blocked.1.count)) ?? "",
                                                    font: .monoDigit(style: .title2, weight: .regular),
                                                    color: .secondaryLabelColor))
                                },
                                dates: blocked.1)
                        }
                }
                .subscribe(info)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .map { _ in
                    nil
                }
                .subscribe(show)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .sink { [weak self] in
                    let result = $0
                        .reduce(into: (items: Set<CollectionItem<Info>>(), y: Self.insets)) {
                            let height = ceil($1.title.height(for: Cell.titleWidth) + New.Cell.insets2)
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
                    self?.height.send(result.y + Self.insets)
                }
                .store(in: &subs)
            
            selected
                .compactMap {
                    $0
                }
                .map {
                    info.value[$0].dates
                }
                .subscribe(show)
                .store(in: &subs)
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
