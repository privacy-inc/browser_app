import AppKit

extension New.History {
    final class Cell: CollectionCell {
        static let insets = CGFloat(10)
        static let insets2 = insets * 2
        
        override var insets: CGFloat {
            Self.insets
        }
        
        override var none: CGColor {
            NSColor.controlBackgroundColor.cgColor
        }
        
        override var highlighted: CGColor {
            NSColor.windowBackgroundColor.cgColor
        }
        
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) { super.init(layer: layer) }
        required init() {
            super.init()
            cornerRadius = 6
        }
    }
}
