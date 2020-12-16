import AppKit
import Sleuth

extension History {
    final class Cell: CALayer {
        var highlighted = false {
            didSet {
                borderWidth = highlighted ? 12 : 0
            }
        }
        
        var item: Page?
        var index = 0
        
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) { super.init(layer: layer) }
        override init() {
            super.init()
            contentsGravity = .resizeAspectFill
            masksToBounds = true
            borderColor = .init(gray: 1, alpha: 0.6)
        }
        
        func update(_ frame: CGRect) {
            ["bounds", "position"].forEach {
                let transition = CABasicAnimation(keyPath: $0)
                transition.duration = 0.3
                transition.timingFunction = .init(name: .easeOut)
                add(transition, forKey: $0)
            }
            self.frame = frame
        }
        
        override class func defaultAction(forKey: String) -> CAAction? {
            switch forKey {
            case "contents": return opacity
            default: return NSNull()
            }
        }
        
        private static var opacity: CABasicAnimation = {
            $0.duration = 0.6
            $0.timingFunction = .init(name: .easeOut)
            $0.fromValue = 0
            return $0
        } (CABasicAnimation(keyPath: "opacity"))
    }
}
