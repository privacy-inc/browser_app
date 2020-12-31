import Foundation
import CoreGraphics

extension History {
    struct Size {
        let lines: Int
        let width: CGFloat
        private static let horizontal = CGFloat(6)
        private static let width = CGFloat(170)
        
        init(size: CGSize) {
            
            let total = size.width - (Self.horizontal * 3)
            let width = Self.width + Self.horizontal
            let count = floor(total / width)
            let delta = total.truncatingRemainder(dividingBy: width) / count
            
            
            self.width = Self.width + delta
            lines = .init(size.width / self.width)
            print(self.width)
        }
    }
}
