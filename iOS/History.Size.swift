import Foundation
import CoreGraphics

extension History {
    struct Size {
        let lines: Int
        let width: CGFloat
        private static let horizontal = CGFloat(6)
        private static let widthSmall = CGFloat(170)
        private static let widthBig = CGFloat(200)
        
        init(size: CGSize) {
            let currentWidth = size.width > 550 ? Self.widthBig : Self.widthSmall
            let total = size.width - (Self.horizontal * 3)
            let width = currentWidth + Self.horizontal
            let count = floor(total / width)
            let delta = total.truncatingRemainder(dividingBy: width) / count
            self.width = currentWidth + delta
            lines = .init(size.width / self.width)
        }
    }
}
