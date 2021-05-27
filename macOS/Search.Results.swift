import AppKit

extension Search {
    final class Results: NSView {
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            super.init(frame: .init(x: 0, y: 0, width: 0, height: 0))
            wantsLayer = true
            layer!.backgroundColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
        }
    }
}
