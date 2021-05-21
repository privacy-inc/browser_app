import UIKit

extension Tab.Find {
    final class Coordinator: UIView, UIKeyInput, UITextFieldDelegate {
        private weak var field: UITextField!
        private weak var _next: UIButton!
        private weak var _prev: UIButton!
        private var editable = true
        private let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 48), inputViewStyle: .keyboard)
        private let wrapper: Tab.Find
        override var inputAccessoryView: UIView? { input }
        override var canBecomeFirstResponder: Bool { editable }
        
        var hasText: Bool {
            get {
                field.text?.isEmpty == false
            }
            set { }
        }
        
        required init?(coder: NSCoder) { nil }
        init(wrapper: Tab.Find) {
            self.wrapper = wrapper
            super.init(frame: .zero)
            
            let field = UITextField()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.clearButtonMode = .always
            field.autocorrectionType = .no
            field.autocapitalizationType = .none
            field.spellCheckingType = .yes
            field.backgroundColor = UIApplication.dark ? .init(white: 1, alpha: 0.2) : .init(white: 1, alpha: 0.6)
            field.tintColor = .label
            field.allowsEditingTextAttributes = false
            field.delegate = self
            field.borderStyle = .roundedRect
            field.returnKeyType = .search
            field.leftViewMode = .always
            input.addSubview(field)
            self.field = field
            
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
            
            let cancel = UIButton()
            
            cancel.setImage(UIImage(systemName: "xmark")?
                                .withConfiguration(UIImage.SymbolConfiguration(textStyle: .callout)), for: .normal)
            cancel.imageView!.tintColor = .secondaryLabel
            cancel.addTarget(self, action: #selector(self.dismiss), for: .touchUpInside)
            
            let next = UIButton()
            next.setImage(UIImage(systemName: "chevron.down")?
                                .withConfiguration(UIImage.SymbolConfiguration(textStyle: .callout)), for: .normal)
            next.imageView!.tintColor = .label
            next.addTarget(self, action: #selector(self.forward), for: .touchUpInside)
            next.isEnabled = false
            self._next = next
            
            let previous = UIButton()
            previous.setImage(UIImage(systemName: "chevron.up")?
                                .withConfiguration(UIImage.SymbolConfiguration(textStyle: .callout)), for: .normal)
            previous.imageView!.tintColor = .label
            previous.addTarget(self, action: #selector(self.previous), for: .touchUpInside)
            previous.isEnabled = false
            self._prev = previous
            
            [cancel, next, previous].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.imageEdgeInsets.top = 4
                input.addSubview($0)
            }
            
            field.leftAnchor.constraint(equalTo: cancel.rightAnchor).isActive = true
            field.rightAnchor.constraint(equalTo: previous.leftAnchor, constant: -10).isActive = true
            field.bottomAnchor.constraint(equalTo: input.bottomAnchor, constant: -4).isActive = true
            
            icon.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            icon.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 2).isActive = true
            
            container.widthAnchor.constraint(equalToConstant: 27).isActive = true
            container.heightAnchor.constraint(equalTo: container.widthAnchor).isActive = true
            
            cancel.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor).isActive = true
            next.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor, constant: -5).isActive = true
            previous.rightAnchor.constraint(equalTo: next.leftAnchor, constant: -5).isActive = true
            
            [cancel, next, previous].forEach {
                $0.widthAnchor.constraint(equalToConstant: 50).isActive = true
                $0.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
                $0.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.becomeFirstResponder()
            }
        }
        
        @discardableResult override func becomeFirstResponder() -> Bool {
            DispatchQueue.main.async { [weak self] in
                self?.field.becomeFirstResponder()
            }
            return super.becomeFirstResponder()
        }
        
        func textFieldShouldEndEditing(_: UITextField) -> Bool {
            editable = false
            return true
        }
        
        func textFieldDidEndEditing(_: UITextField) {
            wrapper.find = false
        }
        
        func textFieldShouldReturn(_: UITextField) -> Bool {
            search(true)
            return true
        }
        
        func textFieldDidChangeSelection(_: UITextField) {
            {
                _next.isEnabled = !$0.isEmpty
                _prev.isEnabled = !$0.isEmpty
                if $0.count > 3 {
                    search(true)
                }
            } (query)
        }
        
        func insertText(_: String) { }
        func deleteBackward() { }
        
        private func search(_ forward: Bool) {
            {
                guard !$0.isEmpty else { return }
                wrapper.session.find.send((wrapper.id, $0))
            } (query)
        }
        
        private var query: String {
            field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        @objc private func dismiss() {
            field.resignFirstResponder()
        }
        
        @objc private func forward() {
            search(true)
        }
        
        @objc private func previous() {
            search(false)
        }
    }
}
