import AppKit
import Combine

class Control: NSView {
    var state = Control.State.on {
        didSet {
            update()
        }
    }
    
    var style = Control.Style.none {
        didSet {
            update()
        }
    }
    
    let click = PassthroughSubject<Void, Never>()
    
    override var mouseDownCanMoveWindow: Bool { false }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setAccessibilityElement(true)
        setAccessibilityRole(.button)
        addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .activeInActiveApp, .inVisibleRect], owner: self))
    }
    
    override func resetCursorRects() {
        addCursorRect(bounds, cursor: .pointingHand)
    }
    
    override func mouseEntered(with: NSEvent) {
        guard state == .on else { return }
        state = .highlighted
    }
    
    override func mouseExited(with: NSEvent) {
        guard state == .highlighted else { return }
        state = .on
    }
    
    override func mouseDown(with: NSEvent) {
        guard state == .on || state == .highlighted else { return }
        state = .pressed
    }
    
    override func mouseUp(with: NSEvent) {
        guard state == .highlighted || state == .on || state == .pressed else { return }
        if bounds.contains(convert(with.locationInWindow, from: nil)) {
            state = .highlighted
            click.send()
        } else {
            state = .on
            super.mouseUp(with: with)
        }
    }
    
    func update() {
        switch state {
        case .on: alphaValue = 1
        case .pressed: alphaValue = 0.6
        default: alphaValue = 0.3
        }
    }
}
