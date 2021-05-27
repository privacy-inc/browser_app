import AppKit

extension New.Bookmarks {
    final class Cell: CollectionCell {
        static let insets = CGFloat(10)
        static let insets2 = insets * 2
        
        override var insets: CGFloat {
            Self.insets
        }
    
        override var highlighted: CGColor {
            NSColor.windowBackgroundColor.cgColor
        }
    }
}
