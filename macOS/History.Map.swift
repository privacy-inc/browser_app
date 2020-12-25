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
                let total = bounds.width - (Frame.horizontal * 2) - Frame.padding
                let width = Frame.width + Frame.padding
                let count = floor(total / width)
                let delta = total.truncatingRemainder(dividingBy: width) / count
                size = .init(width: Frame.width + delta, height: Frame.height + max(0, Frame.delta - delta))
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
            var carry = CGPoint(x: Frame.horizontal - size.width, y: Frame.vertical)
            pages.forEach {
                carry.x += size.width + Frame.padding
                if carry.x + size.width > bounds.width - Frame.horizontal {
                    carry = .init(x: Frame.horizontal + Frame.padding, y: carry.y + size.height + Frame.padding)
                }
                positions[$0.id] = carry
            }
            self.positions = positions
            height.send(carry.y + size.height + Frame.vertical)
        }
    }
}
