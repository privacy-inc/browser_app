import SwiftUI
import Combine
import Sleuth

extension Searchbar {
    final class Coordinator: UIView, UIKeyInput, UISearchBarDelegate {
        private weak var bar: UISearchBar!
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
            bar.showsCancelButton = true
            bar.enablesReturnKeyAutomatically = false
            bar.barTintColor = UIColor(named: "AccentColor")!
            bar.tintColor = UIColor(named: "AccentColor")!
            bar.keyboardType = .webSearch
            bar.searchTextField.allowsEditingTextAttributes = false
            bar.delegate = self
            input.addSubview(bar)
            self.bar = bar
            leftView = bar.searchTextField.leftView

            view.session.resign.sink { [weak self] in
                self?.editable = false
                self?.bar.resignFirstResponder()
                self?.editable = true
            }.store(in: &subs)
            
            view.session.type.sink { [weak self] in
                self?.becomeFirstResponder()
            }.store(in: &subs)
            
            bar.leftAnchor.constraint(equalTo: input.leftAnchor).isActive = true
            bar.rightAnchor.constraint(equalTo: input.rightAnchor).isActive = true
            bar.centerYAnchor.constraint(equalTo: input.centerYAnchor).isActive = true
        }
        
        @discardableResult override func becomeFirstResponder() -> Bool {
            DispatchQueue.main.async { [weak self] in
                self?.bar.becomeFirstResponder()
            }
            return super.becomeFirstResponder()
        }
        
        func searchBar(_: UISearchBar, textDidChange: String) {
            if textDidChange.isEmpty && !bar.showsCancelButton {
                bar.setShowsCancelButton(true, animated: true)
                bar.searchTextField.leftView = leftView
            } else if !textDidChange.isEmpty && bar.showsCancelButton {
                bar.setShowsCancelButton(false, animated: true)
                bar.searchTextField.leftView = nil
            }
        }
        
        func searchBarTextDidBeginEditing(_: UISearchBar) {
            view.session.typing = true
        }
        
        func searchBarTextDidEndEditing(_: UISearchBar) {
            view.session.typing = false
        }
        
        func searchBarSearchButtonClicked(_: UISearchBar) {
            bar.text.map {
                Defaults.engine.browse($0).map {
                    switch $0 {
                    case let .search(url):
                        view.session.browser.browse.send(url)
                    case let .navigate(url):
                        view.session.browser.browse.send(url)
                        bar.text = nil
                    }
                }
                view.session.resign.send()
            }
        }
        
        func searchBarCancelButtonClicked(_: UISearchBar) {
            view.session.resign.send()
        }
        
        func insertText(_ text: String) { }
        func deleteBackward() { }
    }
}
