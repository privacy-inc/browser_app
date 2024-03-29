import AppKit
import Combine

final class Bar: NSVisualEffectView {
    private var right: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            right?.isActive = true
        }
    }
    
    private var subs = Set<AnyCancellable>()
    private let session: Session
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        self.session = session
        super.init(frame: .zero)
        material = .menu
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
                self?.render()
                session.search.send(tab)
            }
            .store(in: &subs)
        
        session
            .open
            .sink { [weak self] (url: URL, change: Bool) in
                cloud
                    .navigate(url) { browse, _ in
                        let tab = session
                            .tab
                            .browse(browse)
                        if change {
                            session
                                .current
                                .send(tab)
                        }
                        self?.render()
                    }
            }
            .store(in: &subs)
        
        session
            .close
            .sink { [weak self] id in
                session
                    .tab
                    .items
                    .value[web: id]
                    .flatMap {
                        $0 as? Web
                    }
                    .map {
                        $0.clear()
                    }
                session
                    .tab
                    .close(id)
                self?
                    .tabs
                    .filter {
                        $0.id == id
                    }
                    .forEach {
                        $0.removeFromSuperview()
                    }
                
                self?.render()
                
                if id == session.current.value {
                    session
                        .tab
                        .items
                        .value
                        .ids
                        .first
                        .map {
                            session
                                .current
                                .send($0)
                            
                            if session
                                .tab
                                .items
                                .value[state: $0].isNew {
                                session
                                    .search
                                    .send($0)
                            }
                        }
                }
            }
            .store(in: &subs)
        
        plus.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        plus.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        render()
    }
    
    private func render() {
        let current = tabs
        right = session
            .tab
            .items
            .value
            .ids
            .map { id in
                current
                    .first {
                        $0.id == id
                    } ?? {
                        addSubview($0)
                        $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                        
                        return $0
                    } (Tab(session: session, id: id))
            }
            .reduce(safeAreaLayoutGuide.leftAnchor) {
                $1.left = $1.leftAnchor.constraint(equalTo: $0, constant: 10)
                return $1.rightAnchor
            }
            .constraint(lessThanOrEqualTo: rightAnchor, constant: -50)
        NSAnimationContext
            .runAnimationGroup {
                $0.allowsImplicitAnimation = true
                $0.duration = 0.5
                layoutSubtreeIfNeeded()
            }
    }
    
    private var tabs: [Tab] {
        subviews
            .compactMap {
                $0 as? Tab
            }
    }
}
