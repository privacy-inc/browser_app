import Foundation
import Combine
import Sleuth

extension Trackers {
    final class List: Collection<Cell, Info> {
        static let width = CGFloat(200)
        static let insets2 = insets + insets
        private static let insets = insets_2 + insets_2
        private static let insets_2 = CGFloat(10)
        
        required init?(coder: NSCoder) { nil }
        init(sorted: CurrentValueSubject<Sleuth.Trackers, Never>, show: PassthroughSubject<[Date]?, Never>) {
            super.init()
            
            let info = CurrentValueSubject<[Info], Never>([])
            
            cloud
                .archive
                .combineLatest(sorted
                                .removeDuplicates())
                .map {
                    ($0.0.trackers($0.1), $0.1)
                }
                .map { (list: [(String, [Date])], sorted: Sleuth.Trackers) in
                    list
                        .map { blocked in
                            .init(
                                id: blocked.0,
                                text: .make {
                                    switch sorted {
                                    case .attempts:
                                        $0.append(.make(NumberFormatter
                                                            .decimal
                                                            .string(from: .init(value: blocked.1.count)) ?? "",
                                                        font: .monoDigit(style: .title2, weight: .regular),
                                                        color: .labelColor))
                                    case .recent:
                                        $0.append(.make(blocked
                                                            .1
                                                            .last
                                                            .map {
                                                                RelativeDateTimeFormatter().string(from: $0)
                                                            }
                                                            ?? "",
                                                            font: .preferredFont(forTextStyle: .callout),
                                                            color: .labelColor))
                                    }
                                    
                                    $0.linebreak()
                                    $0.append(.make(blocked.0,
                                                    font: .preferredFont(forTextStyle: .callout),
                                                    color: .secondaryLabelColor))
                                },
                                dates: blocked.1)
                        }
                }
                .subscribe(info)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .combineLatest(selected
                                .compactMap {
                                    $0
                                }
                                .removeDuplicates())
                .map { info, selected in
                    info
                        .contains {
                            $0.id == selected
                        } ? selected : nil
                }
                .sink { [weak self] in
                    self?.selected.send($0)
                }
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .combineLatest(selected
                                .compactMap {
                                    $0
                                }
                                .removeDuplicates())
                .map { info, selected in
                    info
                        .first {
                            $0.id == selected
                        }?.dates
                }
                .subscribe(show)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .sink { [weak self] in
                    let result = $0
                        .reduce(into: (items: Set<CollectionItem<Info>>(), y: Self.insets_2)) {
                            let height = ceil($1.text.height(for: Cell.width) + Cell.insets2)
                            $0.items.insert(.init(
                                                info: $1,
                                                rect: .init(
                                                    x: Self.insets,
                                                    y: $0.y,
                                                    width: Self.width,
                                                    height: height)))
                            $0.y += height + 2
                        }
                    self?.first.send($0.first?.id)
                    self?.items.send(result.items)
                    self?.height.send(result.y + Self.insets_2)
                }
                .store(in: &subs)
        }
    }
}
