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

        override func fieldEditor(for: NSView) -> NSTextView? {
            editor
        }
        
        override func focusRingMaskBounds(forFrame: NSRect, in: NSView) -> NSRect {
            forFrame.insetBy(dx: -19, dy: 1)
        }
        
        override func drawFocusRingMask(withFrame: NSRect, in: NSView) {
            NSBezierPath(roundedRect: withFrame.insetBy(dx: -19, dy: 1), xRadius: 3, yRadius: 3).fill()
        }
    }
}
