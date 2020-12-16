import AppKit
import Sleuth

final class Tabbar: NSView {
    required init?(coder: NSCoder) { nil }
    init(tab: Tab) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
}
