import AppKit

class CollectionCell<Info>: CALayer where Info : CollectionItemInfo {
    var first = false
    var item: CollectionItem<Info>?
    
    required init?(coder: NSCoder) { nil }
    override init(layer: Any) { super.init(layer: layer) }
    required override init() {
        super.init()
    }
    
    final var state = CollectionCellState.none {
        didSet {
            switch state {
            case .none:
                backgroundColor = .clear
            case .highlighted, .pressed:
                backgroundColor = NSColor.quaternaryLabelColor.cgColor
            }
        }
    }
    
    final override func hitTest(_: CGPoint) -> CALayer? {
        nil
    }
    
    final override class func defaultAction(forKey: String) -> CAAction? {
        NSNull()
    }
}
