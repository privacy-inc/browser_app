import QuartzCore

final class Shape: CAShapeLayer {
    override class func defaultAction(forKey: String) -> CAAction? {
        NSNull()
    }
}
