import AppKit
import Combine

final class Bar: NSVisualEffectView {
    required init?(coder: NSCoder) { nil }
    init(current: CurrentValueSubject<UUID, Never>) {
        super.init(frame: .zero)
        material = .popover
        state = .active
        isEmphasized = true
        
        let tab = Tab(id: current.value, current: current)
        addSubview(tab)
        
        tab.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        tab.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
    }
}
