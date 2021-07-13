import AppKit
import Combine

final class Bar: NSView {
    required init?(coder: NSCoder) { nil }
    init(current: CurrentValueSubject<UUID, Never>) {
        super.init(frame: .zero)
        
        let tab = Tab(id: current.value, current: current)
        addSubview(tab)
        
        tab.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        tab.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
    }
}
