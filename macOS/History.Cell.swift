import AppKit
import Sleuth

extension History {
    final class Cell: CATextLayer {
        var highlighted = false {
            didSet {
                borderWidth = highlighted ? 12 : 0
            }
        }
        
        var item: Page? {
            didSet {
//                contents = item?.title
                print(item?.title)
                
//                let textlayer = CATextLayer()

//                textlayer.frame = CGRect(x: 20, y: 20, width: 200, height: 18)
                fontSize = 12
                alignmentMode = .center
                string = item?.title ?? ""
                isWrapped = true
                truncationMode = .end
            }
        }
        var index = 0
        
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) { super.init(layer: layer) }
        override init() {
            super.init()
            masksToBounds = true
            borderColor = .init(gray: 1, alpha: 0.6)
            backgroundColor = NSColor.red.cgColor
            contentsScale = NSScreen.main?.backingScaleFactor ?? 2
            foregroundColor = NSColor.labelColor.cgColor
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
