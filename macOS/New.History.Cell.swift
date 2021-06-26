import AppKit

extension New.History {
    final class Cell: CollectionCell {
        static let insets = CGFloat(12)
        static let insets2 = insets * 2
        
        override var insets: CGFloat {
            Self.insets
        }
        
        override var highlighted: CGColor {
            NSColor.controlBackgroundColor.cgColor
        }
        
        override var pressed: CGColor {
            NSColor.selectedTextBackgroundColor.cgColor
        }
        
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) { super.init(layer: layer) }
        required init() {
            super.init()
            cornerRadius = 8
        }
    }
}
