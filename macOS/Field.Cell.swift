import AppKit

extension Field {
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
            super.drawingRect(forBounds: forBounds
                                .offsetBy(dx: 0, dy: -1))
        }
        
        override func fieldEditor(for: NSView) -> NSTextView? {
            editor
        }
        
        override func focusRingMaskBounds(forFrame: NSRect, in: NSView) -> NSRect {
            forFrame.ring
        }
        
        override func drawFocusRingMask(withFrame: NSRect, in: NSView) {
            NSBezierPath(roundedRect: withFrame.ring, xRadius: 5, yRadius: 5).fill()
        }
    }
}

private extension NSRect {
    var ring: Self {
        insetBy(dx: -19.5, dy: 1)
            .offsetBy(dx: 0, dy: -0.5)
    }
}
