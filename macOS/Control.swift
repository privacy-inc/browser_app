import AppKit
import Combine

class Control: NSView {
    final var state = Control.State.on {
        didSet {
            update()
        }
    }
    
    final let click = PassthroughSubject<Void, Never>()
    
    final override var mouseDownCanMoveWindow: Bool { false }
    
    required init?(coder: NSCoder) { nil }
    init(layer: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = layer
        setAccessibilityElement(true)
        setAccessibilityRole(.button)
        addTrackingArea(.init(rect: bounds, options: [.mouseEnteredAndExited, .activeInActiveApp, .inVisibleRect], owner: self))
        update()
    }
    
    final override func resetCursorRects() {
        addCursorRect(bounds, cursor: .arrow)
    }
    
    final override func mouseEntered(with: NSEvent) {
        guard state == .on || state == .pressed else { return }
        state = .highlighted
    }
    
    final override func mouseExited(with: NSEvent) {
        guard state == .highlighted || state == .pressed else { return }
        state = .on
    }
    
    final override func mouseDown(with: NSEvent) {
        guard with.clickCount == 1 else {
            super.mouseDown(with: with)
            return
        }
        guard state == .on || state == .highlighted || state == .pressed else {
            super.mouseDown(with: with)
            return
        }
        window?.makeFirstResponder(self)
        state = .pressed
    }
    
    final override func mouseUp(with: NSEvent) {
        guard with.clickCount == 1 else {
            super.mouseUp(with: with)
            return
        }
        guard state == .highlighted || state == .on || state == .pressed else {
            super.mouseUp(with: with)
            return
        }
        if bounds.contains(convert(with.locationInWindow, from: nil)) {
            click.send()
        } else {
            super.mouseUp(with: with)
        }
        if state == .highlighted || state == .pressed {
            NSAnimationContext
                .runAnimationGroup {
                    $0.duration = 0.5
                    $0.allowsImplicitAnimation = true
                    state = .on
                }
        }
    }
    
    func update() {
        isHidden = state == .hidden
        alphaValue = state == .off ? 0.25 : 1
    }
}
