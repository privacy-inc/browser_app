import QuartzCore

extension Collection.Cell {
    final class Text: CATextLayer {
        override class func defaultAction(forKey: String) -> CAAction? {
            nil
        }
    }
}
