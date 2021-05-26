import QuartzCore

extension New.Bookmarks {
    final class Cell: CATextLayer {
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) { super.init(layer: layer) }
        
        override init() {
            super.init()
        }
        
        override class func defaultAction(forKey: String) -> CAAction? {
            nil
        }
    }
}
