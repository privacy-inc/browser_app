import AppKit

extension Collection {
    final class Cell: CALayer {
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
                backgroundColor = .clear
                state = .none
                
                if let item = item {
                    frame = item.rect
                    text.frame = item.rect.insetBy(dx: 6, dy: 6)
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
                    backgroundColor = .clear
                case .highlighted:
                    backgroundColor = NSColor.controlBackgroundColor.cgColor
                }
            }
        }
        
        override class func defaultAction(forKey: String) -> CAAction? {
            nil
        }
    }
}
