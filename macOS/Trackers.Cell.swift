import AppKit

extension Trackers {
    final class Cell: CollectionCell<Info> {
        static let insets = CGFloat(12)
        static let insets2 = insets * 2
        static let titleWidth = CGFloat(150)
        private weak var title: CollectionCellText!
        private weak var counter: CollectionCellText!
        private weak var separator: CAShapeLayer!
        
        override var first: Bool {
            didSet {
                separator.isHidden = first
            }
        }
        
        override var frame: CGRect {
            didSet {
                separator.path = .init(rect: .init(x: Self.insets, y: 0, width: frame.width - Self.insets2, height: 0), transform: nil)
            }
        }
        
        override var item: CollectionItem<Info>? {
            didSet {
                if let item = item {
                    frame = item.rect
                    title.frame.size.height = item.rect.height - Self.insets2
                    counter.frame.size.height = item.info.counter.height(for: List.width)
                    counter.frame.origin.y = (item.rect.height - counter.frame.size.height) / 2
                    title.string = item.info.title
                    counter.string = item.info.counter
                } else {
                    title.string = nil
                    counter.string = nil
                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        required init() {
            super.init()
            cornerRadius = 8
            
            let title = CollectionCellText()
            title.frame = .init(
                x: Self.insets,
                y: Self.insets,
                width: Self.titleWidth,
                height: 0)
            addSublayer(title)
            self.title = title
            
            let counter = CollectionCellText()
            counter.alignmentMode = .right
            counter.frame = .init(
                x: 0,
                y: 0,
                width: List.width - Self.insets,
                height: 0)
            addSublayer(counter)
            self.counter = counter
            
            let separator = CAShapeLayer()
            separator.fillColor = .clear
            separator.lineWidth = 1
            separator.strokeColor = NSColor.separatorColor.cgColor
            addSublayer(separator)
            self.separator = separator
        }
    }
}
