import AppKit
import Combine

class Control: NSView {
    var state = Control.State.on {
        didSet {
            update()
        }
    }
    
    let click = PassthroughSubject<Void, Never>()
    
    override var mouseDownCanMoveWindow: Bool { false }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        wantsLayer = true
        layer!.cornerRadius = 6
        translatesAutoresizingMaskIntoConstraints = false
        setAccessibilityElement(true)
        setAccessibilityRole(.button)
        addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .activeInActiveApp, .inVisibleRect], owner: self))
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
        guard state == .on || state == .highlighted else {
            super.mouseDown(with: with)
            return
        }
        window?.makeFirstResponder(self)
        state = .pressed
    }
    
    override func mouseUp(with: NSEvent) {
        guard state == .highlighted || state == .on || state == .pressed else { return }
        if bounds.contains(convert(with.locationInWindow, from: nil)) {
            state = .on
            click.send()
        } else {
            state = .on
            super.mouseUp(with: with)
        }
    }
    
    func update() {
        switch state {
        case .off:
            alphaValue = 0.3
        default:
            alphaValue = 1
        }
        
        switch state {
        case .highlighted:
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
        case .pressed:
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
        default:
            layer!.backgroundColor = .clear
        }
    }
}
