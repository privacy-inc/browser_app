import AppKit

extension Collection {
    class Cell: CALayer {
        var insetX = CGFloat()
        var insetY = CGFloat()
        var colorNone = CGColor.clear
        var colorHighlighted = CGColor.clear
        
        private weak var text: Text!
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) { super.init(layer: layer) }
        override init() {
            super.init()
            let text = Text()
            addSublayer(text)
            self.text = text
        }
        
        var item: Item? {
            didSet {
                state = .none
                
                if let item = item {
                    frame = item.rect
                    text.frame = item.rect.insetBy(dx: insetX, dy: insetY)
                    text.string = item.string
                } else {
                    text.string = nil
                }
            }
        }
        
        var state = State.none {
            didSet {
                switch state {
                case .none:
                    backgroundColor = colorNone
                case .highlighted:
                    backgroundColor = colorHighlighted
                }
            }
        }
        
        final override class func defaultAction(forKey: String) -> CAAction? {
            nil
        }
    }
}
