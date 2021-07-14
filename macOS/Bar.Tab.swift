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
            
            let icon = Favicon(id: id)
            
            current
                .map {
                    $0 == id
                }
                .removeDuplicates()
                .sink { [weak self] in
                    self?.view($0 ? Search(id: id, icon: icon) : Thumbnail(id: id, icon: icon))
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
            
            content.topAnchor.constraint(equalTo: topAnchor).isActive = true
            content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            content.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        }
    }
}
