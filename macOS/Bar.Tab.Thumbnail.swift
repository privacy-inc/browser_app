import AppKit

extension Bar.Tab {
    final class Thumbnail: NSView {
        required init?(coder: NSCoder) { nil }
        init(id: UUID, icon: Icon) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
