import SwiftUI
import Combine
import Sleuth

extension Searchbar {
    final class Coordinator: UISearchBar, UISearchBarDelegate {
        private var subs = Set<AnyCancellable>()
        private let view: Cell
        
        required init?(coder: NSCoder) { nil }
        init(view: Cell) {
            self.view = view
            super.init(frame: .zero)
            searchBarStyle = .minimal
            autocapitalizationType = .none
            autocorrectionType = .no
            enablesReturnKeyAutomatically = false
            barTintColor = UIColor(named: "AccentColor")!
            tintColor = UIColor(named: "AccentColor")!
            keyboardType = .webSearch
            searchTextField.allowsEditingTextAttributes = false
            searchTextField.clearButtonMode = .never
            searchTextField.leftView = nil
            searchTextField.rightView = nil
            searchTextField.borderStyle = .none
            delegate = self
            
            view.session.resign.sink { [weak self] in
                self?.resignFirstResponder()
            }.store(in: &subs)

            view.session.type.sink { [weak self] in
                self?.becomeFirstResponder()
            }.store(in: &subs)
        }
        
        func searchBarTextDidBeginEditing(_: UISearchBar) {
            view.session.typing = true
        }
        
        func searchBarTextDidEndEditing(_: UISearchBar) {
            view.session.typing = false
        }
        
        func searchBarSearchButtonClicked(_: UISearchBar) {
            text.map {
                Defaults.engine.browse($0).map {
                    switch $0 {
                    case let .search(url):
                        view.session.browser.browse.send(url)
                    case let .navigate(url):
                        view.session.browser.browse.send(url)
                        text = nil
                    }
                }
                resignFirstResponder()
            }
        }
    }
}
