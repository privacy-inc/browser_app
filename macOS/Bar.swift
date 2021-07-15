import AppKit
import Combine

final class Bar: NSVisualEffectView {
    private var tabs: [UUID]
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
        tabs = [id]
        current = .init(id)
        
        super.init(frame: .zero)
        material = .popover
        state = .active
        isEmphasized = true
        
        let plus = Squircle(icon: "plus", size: 18)
        plus
            .click
            .sink { [weak self] in
                self?.add()
            }
            .store(in: &subs)
        addSubview(plus)
        
        plus.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        plus.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        render()
    }
    
    func add() {
        current.value = tabber.new()
        guard !tabs.contains(current.value) else { return }
        tabs.append(current.value)
        render()
        session.search.send(current.value)
    }
    
    private func render() {
        subviews
            .filter {
                $0 is Tab
            }
            .forEach {
                $0.removeFromSuperview()
            }
        
        tabs
            .map {
                Tab(id: $0, current: current)
            }
            .reduce(safeAreaLayoutGuide.leftAnchor) {
                addSubview($1)
                $1.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                $1.leftAnchor.constraint(equalTo: $0, constant: 10).isActive = true
                return $1.rightAnchor
            }
            .constraint(lessThanOrEqualTo: rightAnchor, constant: -50).isActive = true
    }
}
