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
            
            current
                .map {
                    $0 == id
                }
                .removeDuplicates()
                .sink { [weak self] in
                    self?.view($0 ? Search(id: id) : Thumbnail(id: id))
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
