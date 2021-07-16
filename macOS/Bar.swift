import AppKit
import Combine

final class Bar: NSVisualEffectView {
    private var subs = Set<AnyCancellable>()
    private let session: Session
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        self.session = session
        super.init(frame: .zero)
        material = .popover
        state = .active
        isEmphasized = true
        
        let plus = Squircle(icon: "plus", size: 18)
        plus
            .click
            .subscribe(session
                        .plus)
            .store(in: &subs)
        addSubview(plus)
        
        session
            .plus
            .sink { [weak self] in
                let tab = session.tab.new()
                session.current.send(tab)
                session.search.send(tab)
                self?.render()
            }
            .store(in: &subs)
        
        plus.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        plus.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
    
    private func render() {
        subviews
            .filter {
                $0 is Tab
            }
            .forEach {
                $0.removeFromSuperview()
            }
        
        session
            .tab
            .items
            .value
            .ids
            .map {
                Tab(session: session, id: $0)
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
