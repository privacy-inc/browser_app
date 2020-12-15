import AppKit

extension Searchbar.Field {
    final class Cell: NSTextFieldCell {
        var a = NSButtonCell(imageCell: NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: nil))
        
        override func draw(withFrame: NSRect, in view: NSView) {
            super.drawInterior(withFrame: withFrame, in: view)
        }
        
        override func drawInterior(withFrame: NSRect, in: NSView) { }

        override func drawingRect(forBounds: NSRect) -> NSRect {
            alignment = (controlView as! NSTextField) == controlView!.window!.firstResponder ? .left : .center
            var rect = forBounds
            rect.origin.x += 35
            rect.size.width -= 70
            return super.drawingRect(forBounds: rect)
        }
    }
}
