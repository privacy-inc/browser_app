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
            
            let next = UIButton()
            next.translatesAutoresizingMaskIntoConstraints = false
            next.setImage(UIImage(systemName: "doc.text.magnifyingglass"), for: .normal)
            next.imageView!.tintColor = .systemBlue
            next.addTarget(self, action: #selector(search), for: .touchUpInside)
            next.isEnabled = false
            next.imageEdgeInsets.top = 4
            input.addSubview(next)
            self._next = next
            
            field.leftAnchor.constraint(equalTo: cancel.rightAnchor).isActive = true
            field.rightAnchor.constraint(equalTo: next.leftAnchor, constant: -10).isActive = true
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
