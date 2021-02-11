import Foundation
import CoreGraphics

extension History {
    struct Size {
        let lines: Int
        let width: CGFloat
        
        init(size: CGSize) {
            let currentWidth = size.width > 550 ? Frame.history.widthBig : Frame.history.widthSmall
            let total = size.width - (Frame.history.horizontal * 3)
            let width = currentWidth + Frame.history.horizontal
            let count = floor(total / width)
            let delta = total.truncatingRemainder(dividingBy: width) / count
            self.width = currentWidth + delta
            lines = .init(size.width / self.width)
        }
    }
}
