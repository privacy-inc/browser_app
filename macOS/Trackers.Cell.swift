import AppKit

extension Trackers {
    final class Cell: CollectionCell<Info> {
        static let insets = CGFloat(16)
        static let insets2 = insets * 2
        static let width = List.width - insets2
        private weak var text: CollectionCellText!
        private weak var separator: CAShapeLayer!
        
        override var first: Bool {
            didSet {
                separator.isHidden = first
            }
        }
        
        override var item: CollectionItem<Info>? {
            didSet {
                if let item = item {
                    frame = item.rect
                    text.frame.size.height = item.rect.height - Self.insets2
                    text.string = item.info.text
                } else {
                    text.string = nil
                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        required init() {
            super.init()
            cornerRadius = 8
            
            let text = CollectionCellText()
            text.frame = .init(
                x: Self.insets,
                y: Self.insets,
                width: Self.width,
                height: 0)
            text.alignmentMode = .right
            addSublayer(text)
            self.text = text
            
            let separator = CAShapeLayer()
            separator.fillColor = .clear
            separator.lineWidth = 1
            separator.strokeColor = NSColor.separatorColor.cgColor
            separator.path = .init(rect: .init(x: Self.insets, y: 0, width: Self.width, height: 0), transform: nil)
            addSublayer(separator)
            self.separator = separator
        }
    }
}
