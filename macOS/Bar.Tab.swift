import AppKit
import Combine

extension Bar {
    final class Tab: NSView {
        var left: NSLayoutConstraint? {
            didSet {
                oldValue?.isActive = false
                left?.isActive = true
            }
        }
        
        let id: UUID
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(session: Session, id: UUID) {
            self.id = id
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false

            heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            let background = Background(session: session, id: id)
            let icon = Favicon(id: id)
            
            session
                .current
                .map {
                    $0 == id
                }
                .removeDuplicates()
                .sink { [weak self] in
                    self?.view($0
                                ? Search(session: session, id: id, background: background, icon: icon)
                                : Thumbnail(session: session, id: id, icon: icon))
                    
                    NSAnimationContext
                        .runAnimationGroup {
                            $0.allowsImplicitAnimation = true
                            $0.duration = 0.5
                            self?.layoutSubtreeIfNeeded()
                        }
                }
                .store(in: &subs)
            
            session
                .current
                .filter {
                    $0 != id
                }
                .map { _ in
                    
                }
                .filter {
                    session
                        .tab
                        .items
                        .value[state: id]
                        .isNew
                }
                .filter {
                    session
                        .tab
                        .items
                        .value
                        .count > 1
                }
                .sink {
                    session.close.send(id)
                }
                .store(in: &subs)
            
            cloud
                .archive
                .combineLatest(session
                                .tab
                                .items
                                .map {
                                    $0[state: id]
                                        .browse
                                }
                                .compactMap {
                                    $0
                                }
                                .removeDuplicates())
                .map {
                    $0.0
                        .page($0.1)
                        .title
                }
                .removeDuplicates()
                .sink { [weak self] in
                    self?.toolTip = $0
                }
                .store(in: &subs)
        }
        
        private func view(_ content: NSView) {
            subviews
                .forEach {
                    $0.removeFromSuperview()
                }
            addSubview(content)
            
            rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
            
            content.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            content.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        }
    }
}
