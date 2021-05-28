import UIKit

class Keyboard: UIView, UIKeyInput, UITextFieldDelegate {
    final var editable = true
    final let id: UUID
    final let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 48), inputViewStyle: .keyboard)
    final private(set) weak var field: UITextField!
    final private(set) weak var cancel: UIButton!
    final override var inputAccessoryView: UIView? { input }
    final override var canBecomeFirstResponder: Bool { editable }
    
    final var hasText: Bool {
        get {
            field.text?.isEmpty == false
        }
        set { }
    }
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
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
        self.cancel = cancel
        
        field.bottomAnchor.constraint(equalTo: input.bottomAnchor, constant: -4).isActive = true
        
        cancel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancel.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
        cancel.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.becomeFirstResponder()
        }
    }
    
    @discardableResult final override func becomeFirstResponder() -> Bool {
        DispatchQueue.main.async { [weak self] in
            self?.field.becomeFirstResponder()
        }
        return super.becomeFirstResponder()
    }
    
    final func textFieldShouldEndEditing(_: UITextField) -> Bool {
        editable = false
        return true
    }
    
    final func insertText(_: String) { }
    final func deleteBackward() { }
    
    @objc final func dismiss() {
        field.resignFirstResponder()
    }
}
