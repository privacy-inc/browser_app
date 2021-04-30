import UIKit
import Combine
import Sleuth

extension Field {
    final class Coordinator: UIView, UIKeyInput, UISearchBarDelegate {
        private weak var bar: UISearchBar!
        private weak var findWidth: NSLayoutConstraint!
        private var leftView: UIView!
        private var editable = true
        private var subs = Set<AnyCancellable>()
        private let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 62), inputViewStyle: .keyboard)
        private let view: Field
        override var inputAccessoryView: UIView? { input }
        override var canBecomeFirstResponder: Bool { editable }
        
        var hasText: Bool {
            get {
                bar.text?.isEmpty == false
            }
            set { }
        }
        
        required init?(coder: NSCoder) { nil }
        init(view: Field) {
            self.view = view
            super.init(frame: .zero)

            let bar = UISearchBar()
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.searchBarStyle = .minimal
            bar.autocapitalizationType = .none
            bar.autocorrectionType = .no
            bar.spellCheckingType = .yes
            bar.showsCancelButton = true
            bar.enablesReturnKeyAutomatically = false
            bar.barTintColor = .init(white: 0.5, alpha: 1)
            bar.tintColor = .label
            bar.keyboardType = .webSearch
            bar.searchTextField.allowsEditingTextAttributes = false
            bar.delegate = self
            input.addSubview(bar)
            self.bar = bar
            leftView = bar.searchTextField.leftView
            
            let find = UIButton()
            find.translatesAutoresizingMaskIntoConstraints = false
            find.setTitle(NSLocalizedString("Find", comment: ""), for: .normal)
            find.setTitleColor(.label, for: .normal)
            find.setTitleColor(.secondaryLabel, for: .highlighted)
            find.addTarget(self, action: #selector(self.find), for: .touchUpInside)
            input.addSubview(find)
            
            view.session.type.sink { [weak self] in
                self?.becomeFirstResponder()
            }.store(in: &subs)
            
            view.session.text.sink { [weak self] in
                self?.bar.text = $0
            }.store(in: &subs)
            
            bar.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor).isActive = true
            bar.leftAnchor.constraint(equalTo: find.rightAnchor).isActive = true
            bar.centerYAnchor.constraint(equalTo: input.centerYAnchor).isActive = true
            
            find.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
            find.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
            find.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor).isActive = true
            findWidth = find.widthAnchor.constraint(equalToConstant: 0)
            findWidth.isActive = true
        }
        
        @discardableResult override func becomeFirstResponder() -> Bool {
            DispatchQueue.main.async { [weak self] in
                self?.bar.becomeFirstResponder()
                self?.bar.searchTextField.selectAll(nil)
                self?.changed()
            }
            return super.becomeFirstResponder()
        }
        
        func searchBar(_: UISearchBar, textDidChange: String) {
            changed()
        }
        
        func searchBarShouldEndEditing(_: UISearchBar) -> Bool {
            editable = false
            return true
        }
        
        func searchBarTextDidEndEditing(_: UISearchBar) {
            editable = true
        }
        
        func searchBarSearchButtonClicked(_: UISearchBar) {
            bar.text.map {
                var sub: AnyCancellable?
                sub = Synch.cloud.browse($0)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] in
                        sub?.cancel()
                        $0.map {
                            switch $0.0 {
                            case .navigate:
                                self?.bar.text = nil
                                self?.changed()
                            default: break
                            }
                            self?.view.session.section = .browse($0.1)
                        }
                    }
                bar.resignFirstResponder()
            }
        }
        
        func searchBarCancelButtonClicked(_: UISearchBar) {
            view.session.search = ""
            bar.resignFirstResponder()
        }
        
        func insertText(_: String) { }
        func deleteBackward() { }
        
        private func changed() {
            bar.text.map {
                if $0.isEmpty == true {
                    bar.searchTextField.leftView = leftView
                    findWidth.constant = 0
                } else {
                    bar.searchTextField.leftView = nil
                    switch view.session.section {
                    case .history:
                        findWidth.constant = 0
                    case .browse:
                        findWidth.constant = 60
                    }
                }
                view.session.search = $0
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.input.layoutIfNeeded()
                }
            }
        }
        
        @objc private func find() {
            bar.resignFirstResponder()
            bar.text.map {
                view.session.find.send($0)
            }
        }
    }
}
