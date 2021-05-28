import UIKit

extension Tab.Find {
    final class Coordinator: Keyboard {
        private weak var _next: UIButton!
        private let wrapper: Tab.Find
        
        required init?(coder: NSCoder) { nil }
        init(wrapper: Tab.Find, id: UUID) {
            self.wrapper = wrapper
            super.init(id: id)
            field.returnKeyType = .search
            field.leftViewMode = .always
            
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.isUserInteractionEnabled = false
            
            let icon = UIImageView(image: .init(systemName: "doc.text.magnifyingglass"))
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.contentMode = .center
            icon.clipsToBounds = true
            icon.tintColor = .secondaryLabel
            container.addSubview(icon)
            
            field.leftView = container
            
            let next = UIButton()
            next.translatesAutoresizingMaskIntoConstraints = false
            next.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            next.imageView!.tintColor = .label
            next.addTarget(self, action: #selector(search), for: .touchUpInside)
            next.isEnabled = false
            next.imageEdgeInsets.top = 4
            input.addSubview(next)
            self._next = next
            
            field.leftAnchor.constraint(equalTo: cancel.rightAnchor).isActive = true
            field.rightAnchor.constraint(equalTo: next.leftAnchor, constant: -10).isActive = true
            
            icon.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            icon.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 2).isActive = true
            
            container.widthAnchor.constraint(equalToConstant: 27).isActive = true
            container.heightAnchor.constraint(equalTo: container.widthAnchor).isActive = true
            
            cancel.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor).isActive = true
            next.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
            next.widthAnchor.constraint(equalToConstant: 50).isActive = true
            next.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
            next.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
        }
        
        func textFieldDidEndEditing(_: UITextField) {
            wrapper.find = false
        }
        
        func textFieldShouldReturn(_: UITextField) -> Bool {
            search()
            return true
        }
        
        func textFieldDidChangeSelection(_: UITextField) {
            {
                _next.isEnabled = !$0.isEmpty
                if $0.count > 3 {
                    search()
                }
            } (query)
        }
        
        private var query: String {
            field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        @objc private func search() {
            {
                guard !$0.isEmpty else { return }
                wrapper.session.find.send((id: wrapper.id, query: $0))
            } (query)
        }
    }
}
