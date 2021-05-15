import Foundation
import CoreGraphics

extension Tab.New.History {
    struct Metrics {
        let columns: Int
        let width: CGFloat
        let spacing = CGFloat(6)
        
        init(size: CGSize) {
            let aprox = size.width > 550 ? CGFloat(200) : 160
            let total = size.width - (spacing * 3)
            let width_spacing = aprox + spacing
            let count = floor(total / width_spacing)
            let delta = total.truncatingRemainder(dividingBy: width_spacing) / count
            width = aprox + delta
            columns = .init(size.width / width)
        }
    }
}
