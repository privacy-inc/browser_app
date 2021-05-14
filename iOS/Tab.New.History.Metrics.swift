import Foundation
import CoreGraphics

extension Tab.New.History {
    struct Metrics {
        let columns: Int
        let width: CGFloat
        let spacing = CGFloat(6)
        
        init(size: CGSize) {
            let currentWidth = size.width > 550 ? CGFloat(200) : 160
            let total = size.width - (spacing * 3)
            let width = currentWidth + spacing
            let count = floor(total / width)
            let delta = total.truncatingRemainder(dividingBy: width) / count
            self.width = currentWidth + delta
            columns = .init(size.width / self.width)
        }
    }
}
