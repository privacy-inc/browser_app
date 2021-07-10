import AppKit

extension New {
    final class Cell: CollectionCell<Info> {
        static let insets = CGFloat(20)
        static let insets2 = insets * 2
        private weak var text: CollectionCellText!
        private weak var separator: CAShapeLayer!
        
        override var first: Bool {
            didSet {
                separator.isHidden = first
            }
        }
        
        override var frame: CGRect {
            didSet {
                separator.path = .init(rect: .init(x: Self.insets, y: -1, width: frame.width - Self.insets2, height: 0), transform: nil)
            }
        }
        
        override var item: CollectionItem<Info>? {
            didSet {
                if let item = item {
                    frame = item.rect
                    text.frame.size = .init(width: item.rect.width - Self.insets2, height: item.rect.height - Self.insets2)
                    text.string = item.info.string
                } else {
                    text.string = nil
                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        required init() {
            super.init()
            cornerRadius = 6
            
            let text = CollectionCellText()
            text.frame = .init(
                x: Self.insets,
                y: Self.insets,
                width: 0,
                height: 0)
            addSublayer(text)
            self.text = text
            
            let separator = CAShapeLayer()
            separator.fillColor = .clear
            separator.lineWidth = 1
            separator.strokeColor = NSColor.separatorColor.cgColor
            addSublayer(separator)
            self.separator = separator
        }
    }
}
