import AppKit

extension Bar {
    final class Thumbnail: NSView {
        required init?(coder: NSCoder) { nil }
        init(id: UUID, icon: Favicon) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
