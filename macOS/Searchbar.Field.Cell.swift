import AppKit

extension Searchbar.Field {
    final class Cell: NSSearchFieldCell {
        var a = NSButtonCell(imageCell: NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: nil))
        
        override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
            print("a")
//            super.draw(withFrame: cellFrame, in: controlView)
            super.drawInterior(withFrame: cellFrame, in: controlView)
        }
        
        override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
            print("b")
//            super.drawInterior(withFrame: cellFrame, in: controlView)
        }
//
        override func drawingRect(forBounds rect: NSRect) -> NSRect {
            print("c")
//            print("rect \(rect) result \(super.drawingRect(forBounds: rect))")
//            print(self.searchButtonRect(forBounds: rect))
            return super.drawingRect(forBounds: rect)
        }

        override func drawFocusRingMask(withFrame cellFrame: NSRect, in controlView: NSView) {
            print("d")
            var frame = cellFrame
            frame.size.height += 10
            super.drawFocusRingMask(withFrame: frame, in: controlView)
        }
    }
}
