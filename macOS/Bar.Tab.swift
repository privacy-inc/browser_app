import AppKit
import Combine

extension Bar {
    final class Tab: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(session: Session, id: UUID) {
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
