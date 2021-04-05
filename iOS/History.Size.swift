import Foundation
import CoreGraphics

extension History {
    struct Size {
        let lines: Int
        let width: CGFloat
        
        init(size: CGSize) {
            let currentWidth = size.width > 550 ? Metrics.history.widthBig : Metrics.history.widthSmall
            let total = size.width - (Metrics.history.spacing * 3)
            let width = currentWidth + Metrics.history.spacing
            let count = floor(total / width)
            let delta = total.truncatingRemainder(dividingBy: width) / count
            self.width = currentWidth + delta
            lines = .init(size.width / self.width)
        }
    }
}
