import AppKit

class CollectionCell: CALayer {
    var insets: CGFloat {
        0
    }
    
    var none: CGColor {
        .clear
    }
    
    var highlighted: CGColor {
        .clear
    }
    
    var pressed: CGColor {
        .clear
    }
    
    private var insets2: CGFloat {
        insets + insets
    }
    
    private(set) weak var text: CollectionCellText!
    required init?(coder: NSCoder) { nil }
    override init(layer: Any) { super.init(layer: layer) }
    required override init() {
        super.init()
        let text = CollectionCellText()
        addSublayer(text)
        self.text = text
    }
    
    final var item: CollectionItem? {
        didSet {
            state = .none
            if let item = item {
                frame = item.rect
                text.frame = .init(
                    x: insets,
                    y: insets,
                    width: item.rect.width - insets2,
                    height: item.rect.height - insets2)
                text.string = item.info.string
            } else {
                text.string = nil
            }
        }
    }
    
    final var state = CollectionCellState.none {
        didSet {
            switch state {
            case .none:
                backgroundColor = none
            case .highlighted:
                backgroundColor = highlighted
            case .pressed:
                backgroundColor = pressed
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
