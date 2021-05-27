import QuartzCore

extension New.History {
    final class Cell: CollectionCell {
        static let insets = CGFloat(4)
        static let insets2 = insets * 2
        
        override var insets: CGFloat {
            Self.insets
        }
    }
}
