import UIKit
import Combine

extension Search.Bar {
    final class Coordinator: UIView, UIKeyInput, UITextFieldDelegate {
        private weak var field: UITextField!
        private var editable = true
        private var filter = false
        private var subs = Set<AnyCancellable>()
        private let wrapper: Search.Bar
        private let id: UUID
        private let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 48), inputViewStyle: .keyboard)
        override var inputAccessoryView: UIView? { input }
        override var canBecomeFirstResponder: Bool { editable }
        
        var hasText: Bool {
            get {
                field.text?.isEmpty == false
            }
            set { }
        }
        
        required init?(coder: NSCoder) { nil }
        init(wrapper: Search.Bar, id: UUID) {
            self.wrapper = wrapper
            self.id = id
            super.init(frame: .zero)
            
            let field = UITextField()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.clearButtonMode = .always
            field.autocorrectionType = .no
            field.autocapitalizationType = .none
            field.spellCheckingType = .yes
            field.backgroundColor = UIApplication.dark ? .init(white: 1, alpha: 0.2) : .init(white: 1, alpha: 0.6)
            field.tintColor = .label
            field.keyboardType = .webSearch
            field.allowsEditingTextAttributes = false
            field.delegate = self
            field.borderStyle = .roundedRect
            input.addSubview(field)
            self.field = field
            
            let cancel = UIButton()
            cancel.translatesAutoresizingMaskIntoConstraints = false
            cancel.setImage(UIImage(systemName: "xmark")?
                                .withConfiguration(UIImage.SymbolConfiguration(textStyle: .callout)), for: .normal)
            cancel.imageEdgeInsets.top = 4
            cancel.imageView!.tintColor = .secondaryLabel
            cancel.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
            input.addSubview(cancel)
            
            field.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
            field.rightAnchor.constraint(equalTo: cancel.leftAnchor).isActive = true
            field.bottomAnchor.constraint(equalTo: input.bottomAnchor, constant: -4).isActive = true
            
            cancel.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor).isActive = true
            cancel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            cancel.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
            cancel.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
            
            wrapper
                .session.tabs.state(wrapper.id).browse
                .map(wrapper.session.archive.page)
                .map(\.access.string)
                .map {
                    field.text = $0
                }
            
            wrapper
                .session
                .search
                .sink { [weak self] in
                    self?.editable = true
                    self?.becomeFirstResponder()
                }
                .store(in: &subs)
            
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
        
        func textFieldDidBeginEditing(_: UITextField) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.field.selectAll(nil)
                self?.filter = true
            }
        }
        
        func textFieldShouldEndEditing(_: UITextField) -> Bool {
            editable = false
            return true
        }
        
        func textFieldDidEndEditing(_: UITextField) {
            wrapper.dismiss()
        }
        
        func textFieldShouldReturn(_: UITextField) -> Bool {
            filter = false
            let state = wrapper.session.tabs.state(id)
            cloud
                .browse(field.text!, id: state.browse) { [weak self] in
                    guard let id = self?.id else { return }
                    if state.browse == $0 {
                        if case .error = state {
                            tab.browse(id, $0)
                        }
                        self?.wrapper.session.load.send((id: id, access: $1))
                    } else {
                        tab.browse(id, $0)
                    }
                }
            dismiss()
            return true
        }
        
        func textFieldDidChangeSelection(_: UITextField) {
            guard filter else { return }
            wrapper.filter = field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        func insertText(_: String) { }
        func deleteBackward() { }
        
        @objc private func dismiss() {
            field.resignFirstResponder()
        }
    }
}
