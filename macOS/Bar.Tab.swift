import AppKit
import Combine

extension Bar {
    final class Tab: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID, current: CurrentValueSubject<UUID, Never>) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            let background = Background(id: id)
            let icon = Favicon(id: id)
            
            current
                .map {
                    $0 == id
                }
                .removeDuplicates()
                .sink { [weak self] in
                    self?.view($0
                                ? Search(id: id, background: background, icon: icon)
                                : Thumbnail(id: id, icon: icon, current: current))
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
