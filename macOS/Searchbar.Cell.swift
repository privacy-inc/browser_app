import AppKit

extension Searchbar {
    final class Cell: NSTextFieldCell {
        override func draw(withFrame: NSRect, in view: NSView) {
            super.drawInterior(withFrame: withFrame, in: view)
        }
        
        override func drawInterior(withFrame: NSRect, in: NSView) { }

        override func drawingRect(forBounds: NSRect) -> NSRect {
            var rect = forBounds
            rect.origin.x += 23
            rect.size.width -= 46
            return super.drawingRect(forBounds: rect)
        }
    }
}
