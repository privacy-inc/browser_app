import AppKit
import Combine

extension Window {
    final class Content: NSView {
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init(session: Session) {
            super.init(frame: .zero)
            let bar = NSVisualEffectView()
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.material = .popover
            bar.state = .active
            bar.isEmphasized = true
            addSubview(bar)
            
            let separator = Separator(mode: .horizontal)
            bar.addSubview(separator)
            
            sub = session
                .tab
                .items
                .combineLatest(session
                                .current
                                .removeDuplicates())
                .map {
                    (state: $0[state: $1], id: $1)
                }
                .removeDuplicates {
                    $0.state == $1.state && $0.id == $1.id
                }
                .sink { [weak self] in
                    switch $0.state {
                    case .new:
                        let display = New(session: session, id: $0.id)
                        self?.display = display
                    case let .browse(browse):
                        let web = (session.tab.items.value[web: $0.id] as? Web) ?? Web(session: session, id: $0.id, browse: browse)
                        if session.tab.items.value[web: $0.id] == nil {
                            session.tab.update($0.id, web: web)
                        }
                        let browser = Browser(web: web)
                        #warning("move finder to browse")
//                        self?.finder.client = web
//                        self?.finder.findBarContainer = browser
                        self?.display = browser
                        self?.window?.makeFirstResponder(web)
                    case let .error(browse, error):
//                        self?.finder.client = nil
//                        self?.finder.findBarContainer = nil
                        let display = Error(session: session, id: $0.id, browse: browse, error: error)
                        self?.display = display
                        self?.window?.makeFirstResponder(display)
                    }
                }
            
            bar.topAnchor.constraint(equalTo: topAnchor).isActive = true
            bar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            bar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            bar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 1).isActive = true
            
            separator.bottomAnchor.constraint(equalTo: bar.bottomAnchor).isActive = true
            separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
        
        private weak var display: NSView? {
            didSet {
                oldValue?.removeFromSuperview()
                display
                    .map {
                        addSubview($0)
                        
                        $0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 1).isActive = true
                        $0.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                        $0.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
                        $0.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
                    }
            }
        }
    }
}
