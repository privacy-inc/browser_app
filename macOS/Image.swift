import AppKit

final class Image: NSImageView {
    required init?(coder: NSCoder) { nil }
    init(icon: String) {
        super.init(frame: .zero)
        image = .init(systemSymbolName: icon, accessibilityDescription: nil)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    init(named: String) {
        super.init(frame: .zero)
        image = .init(named: named)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var allowsVibrancy: Bool {
        true
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
}
