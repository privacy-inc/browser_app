import AppKit

extension New {
    final class Cell: CollectionCell<Info> {
        static let insets = CGFloat(20)
        static let insets2 = insets * 2
        private weak var text: CollectionCellText!
        private weak var icon: Icon!
        private weak var separator: Shape!
        
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
                guard
                    item != oldValue,
                    let item = item
                else { return }
                frame = item.rect
                text.frame.size = .init(width: item.rect.width - Self.insets2, height: item.rect.height - Self.insets2)
                text.string = item.info.string
                icon.frame.size.height = item.rect.height
                icon.domain.send(item.info.domain)
            }
        }
        
        required init?(coder: NSCoder) { nil }
        required init() {
            super.init()
            cornerRadius = 8
            
            let icon = Icon()
            icon.frame = .init(
                x: Self.insets,
                y: 0,
                width: 18,
                height: 0)
            addSublayer(icon)
            self.icon = icon
            
            let text = CollectionCellText()
            text.frame = .init(
                x: Self.insets + 28,
                y: Self.insets,
                width: 0,
                height: 0)
            addSublayer(text)
            self.text = text
            
            let separator = Shape()
            separator.fillColor = .clear
            separator.lineWidth = 1
            separator.strokeColor = NSColor.separatorColor.cgColor
            addSublayer(separator)
            self.separator = separator
        }
    }
}
