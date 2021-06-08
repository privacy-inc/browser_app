import AppKit

extension Activity {
    final class Viewer: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            wantsLayer = true
        }
        
        override func hitTest(_: NSPoint) -> NSView? {
            nil
        }
    }
}
