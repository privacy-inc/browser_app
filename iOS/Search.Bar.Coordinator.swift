import UIKit
import Combine

extension Search.Bar {
    final class Coordinator: Keyboard {
        private var subs = Set<AnyCancellable>()
        private let wrapper: Search.Bar
        
        required init?(coder: NSCoder) { nil }
        init(wrapper: Search.Bar, id: UUID) {
            self.wrapper = wrapper
            super.init(id: id)
            field.keyboardType = .webSearch
            
            field.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
            field.rightAnchor.constraint(equalTo: cancel.leftAnchor).isActive = true
            
            cancel.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor).isActive = true
            
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
        
        func textFieldDidEndEditing(_: UITextField) {
            wrapper.dismiss()
            field.text = ""
        }
        
        func textFieldShouldReturn(_: UITextField) -> Bool {
            let state = wrapper.session.tab[state: id]
            cloud
                .browse(field.text!, id: state.browse) { [weak self] in
                    guard let id = self?.id else { return }
                    if state.browse == $0 {
                        if state.isError {
                            tabber.browse(id, $0)
                        }
                        self?.wrapper.session.load.send((id: id, access: $1))
                    } else {
                        tabber.browse(id, $0)
                    }
                }
            dismiss()
            return true
        }
        
        func textFieldDidChangeSelection(_: UITextField) {
            wrapper.filter = field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
