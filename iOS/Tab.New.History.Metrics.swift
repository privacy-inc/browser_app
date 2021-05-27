import Foundation
import CoreGraphics

extension Tab.New.History {
    struct Metrics {
        let columns: Int
        let width: CGFloat
        let spacing = CGFloat(6)
        
        init(size: CGSize) {
            let aprox = size.width > 550 ? CGFloat(200) : 160
            let total = size.width - spacing
            let width_spacing = aprox + spacing
            columns = Int(floor(total / width_spacing))
            width = aprox + (total.truncatingRemainder(dividingBy: width_spacing) / .init(columns))
        }
    }
}
