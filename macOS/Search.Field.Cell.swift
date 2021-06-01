import AppKit

extension Search.Field {
    final class Cell: NSTextFieldCell {
        private let editor = Editor()
        
        required init(coder: NSCoder) { super.init(coder: coder) }
        override init(textCell: String) {
            super.init(textCell: textCell)
            truncatesLastVisibleLine = true
        }
        
        override func draw(withFrame: NSRect, in view: NSView) {
            super.drawInterior(withFrame: withFrame, in: view)
        }
        
        override func drawInterior(withFrame: NSRect, in: NSView) { }
        
        override func drawingRect(forBounds: NSRect) -> NSRect {
            var rect = forBounds
            rect.origin.x += 20
            rect.size.width -= 40
            return super.drawingRect(forBounds: rect)
        }
        
        override func fieldEditor(for: NSView) -> NSTextView? {
            editor
        }
        
        override func drawFocusRingMask(withFrame: NSRect, in: NSView) {
            NSBezierPath(roundedRect: withFrame.insetBy(dx: 1, dy: 1), xRadius: 3, yRadius: 3).fill()
            editor.setSelectedRange(.init(location: 0, length: stringValue.count))
            editor.selectedTextAttributes = [.backgroundColor : NSColor.secondaryLabelColor,
                                             .foregroundColor : NSColor.windowBackgroundColor]
        }
    }
}
