import Foundation
import Combine
import Sleuth

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
                let total = bounds.width - (Frame.history.horizontal * 2) - Frame.history.padding
                let width = Frame.history.width + Frame.history.padding
                let count = floor(total / width)
                let delta = total.truncatingRemainder(dividingBy: width) / count
                size = .init(width: Frame.history.width + delta, height: Frame.history.height + max(0, Frame.history.delta - delta))
            }
        }
        
        let items = PassthroughSubject<Set<Item>, Never>()
        let height = PassthroughSubject<CGFloat, Never>()
        
        private var size = CGSize.zero {
            didSet {
                reposition()
            }
        }
        
        private var positions = [UUID : CGPoint]() {
            didSet {
                visible = visibility
            }
        }
        
        private var visible = Set<UUID>() {
            didSet {
                items.send(.init(visible.map { id in .init(
                                    page: pages.first { $0.id == id }!,
                                    frame: .init(origin: positions[id]!, size: size)) }))
            }
        }
        
        private var visibility: Set<UUID> {
            let min = bounds.minY - size.height
            let max = bounds.maxY + 1
            return .init(positions.filter {
                $0.1.y > min && $0.1.y < max
            }.map(\.0))
        }
        
        func page(for point: CGPoint) -> Page? {
            positions
                .map { ($0.0, CGRect(origin: $0.1, size: size)) }
                .first { $0.1.contains(point) }
                .flatMap { item in
                    pages
                        .first { $0.id == item.0 }
                }
        }
        
        private func reposition() {
            var positions = [UUID : CGPoint]()
            var carry = CGPoint(x: Frame.history.horizontal - size.width, y: Frame.history.top)
            pages.forEach {
                carry.x += size.width + Frame.history.padding
                if carry.x + size.width > bounds.width - Frame.history.horizontal {
                    carry = .init(x: Frame.history.horizontal + Frame.history.padding, y: carry.y + size.height + Frame.history.padding)
                }
                positions[$0.id] = carry
            }
            self.positions = positions
            height.send(carry.y + size.height + Frame.history.bottom)
        }
    }
}
