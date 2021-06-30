import AppKit

extension New {
    final class Cell: CollectionCell {
        static let insets = CGFloat(12)
        static let insets2 = insets * 2
        private weak var text: CollectionCellText!
        private weak var separator: CAShapeLayer!
        
        override var first: Bool {
            didSet {
                separator.isHidden = first
            }
        }
        
        override var insets: CGFloat {
            Self.insets
        }
        
        override var highlighted: CGColor {
            NSColor.controlBackgroundColor.cgColor
        }
        
        override var pressed: CGColor {
            NSColor.selectedTextBackgroundColor.cgColor
        }
        
        override var frame: CGRect {
            didSet {
                separator.path = .init(rect: .init(x: insets, y: 0, width: frame.width - Self.insets2, height: 0), transform: nil)
            }
        }
        
        override var item: CollectionItem? {
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
        
        required init?(coder: NSCoder) { nil }
        required init() {
            super.init()
            cornerRadius = 8
            
            let text = CollectionCellText()
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
