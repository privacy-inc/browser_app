import AppKit

extension New {
    final class History: NSView {
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            wantsLayer = true
            layer!.backgroundColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
            layer!.cornerRadius = 12
        }
    }
}
