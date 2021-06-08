import AppKit

final class Selectable: NSTextField {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        isBezeled = false
        isEditable = false
        isSelectable = true
        allowsEditingTextAttributes = true
        setAccessibilityRole(.staticText)
    }
    
    override var acceptsFirstResponder: Bool {
        false
    }
    
    override var canBecomeKeyView: Bool {
        false
    }
    
    override var allowsVibrancy: Bool {
        true
    }
    
    override func acceptsFirstMouse(for: NSEvent?) -> Bool {
        false
    }
}
