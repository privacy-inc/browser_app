import AppKit

extension New {
    final class Cell: CollectionCell {
        static let insets = CGFloat(12)
        static let insets2 = insets * 2
        
        override var insets: CGFloat {
            Self.insets
        }
        
        override var highlighted: CGColor {
            NSColor.windowBackgroundColor.cgColor
        }
        
        override var pressed: CGColor {
            NSColor.controlBackgroundColor.cgColor
        }
        
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) { super.init(layer: layer) }
        required init() {
            super.init()
            cornerRadius = 6
        }
    }
}
