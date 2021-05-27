import AppKit

final class CollectionCellText: CATextLayer {
    required init?(coder: NSCoder) { nil }
    override init(layer: Any) { super.init(layer: layer) }
    override init() {
        super.init()
        contentsScale = NSScreen.main?.backingScaleFactor ?? 2
        isWrapped = true
    }
    
    override class func defaultAction(forKey: String) -> CAAction? {
        NSNull()
    }
}
