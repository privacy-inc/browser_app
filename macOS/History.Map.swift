import Foundation
import Combine

extension History {
    final class Map {
        var pages = [Page]() {
            didSet {
                reposition()
            }
        }
        
        var bounds = CGRect.zero {
            didSet {
                guard bounds.size != oldValue.size else {
                    {
                        guard visible != $0 else { return }
                        self.visible = $0
                    } (visibility)
                    return
                }
                let total = bounds.width - (Metrics.history.horizontal * 2) - Metrics.history.padding
                let horizontal = Metrics.history.width + Metrics.history.padding
                count = .init(floor(total / horizontal))
                let delta = total.truncatingRemainder(dividingBy: horizontal) / .init(count)
                width = Metrics.history.width + delta
            }
        }
        
        let items = PassthroughSubject<Set<Item>, Never>()
        let height = PassthroughSubject<CGFloat, Never>()
        private var count = 0
        
        private var width = CGFloat() {
            didSet {
                reposition()
            }
        }
        
        private var frames = [UUID : CGRect]() {
            didSet {
                visible = visibility
            }
        }
        
        private var visible = Set<UUID>() {
            didSet {
                items.send(.init(visible.map { id in .init(
                                    page: pages.first { $0.page.id == id }!,
                                    frame: frames[id]!) }))
            }
        }
        
        private var visibility: Set<UUID> {
            .init(frames.filter {
                $0.1.maxY > bounds.minY && $0.1.minY < bounds.maxY
            }.map(\.0))
        }
        
        func page(for point: CGPoint) -> Page? {
            frames.first {
                $0.1.contains(point)
            }.flatMap { frame in
                pages.first {
                    $0.page.id == frame.0
                }
            }
        }
        
        private func reposition() {
            guard count > 0 else { return }
            let margin = Metrics.history.margin * 2
            let size = CGSize(width: width - margin, height: 600)
            var maxY = Metrics.history.top
            frames = pages.reduce(into: (Array(repeating: [(CGRect, UUID)](), count: count), count)) {
                $0.1 = $0.1 < count - 1 ? $0.1 + 1 : 0
                $0.0[$0.1].append(
                    (.init(
                        x: $0.0[$0.1].last?.0.minX ?? Metrics.history.horizontal + Metrics.history.padding + ((width + Metrics.history.padding) * .init($0.1)),
                        y: $0.0[$0.1].last.map {
                            $0.0.maxY + Metrics.history.padding
                        } ?? Metrics.history.top,
                        width: width,
                        height: ceil($1.text.boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin]).height) + margin),
                     $1.page.id)
                )
                maxY = max(maxY, $0.0[$0.1].last!.0.maxY)
            }.0.flatMap {
                $0
            }.reduce(into: [:]) {
                $0[$1.1] = $1.0
            }
            
            height.send(maxY + Metrics.history.bottom)
        }
    }
}
