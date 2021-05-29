import AppKit
import Combine

extension Search {
    final class Field: NSTextField, NSTextFieldDelegate {
        override var canBecomeKeyView: Bool { true }
        private var subs = Set<AnyCancellable>()
        private let id: UUID
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            Self.cellClass = Cell.self
            self.id = id
            super.init(frame: .zero)
            bezelStyle = .roundedBezel
            translatesAutoresizingMaskIntoConstraints = false
            font = .preferredFont(forTextStyle: .body)
            controlSize = .large
            delegate = self
            lineBreakMode = .byTruncatingMiddle
            target = self
            action = #selector(search)
            textColor = .labelColor
            isAutomaticTextCompletionEnabled = false

            
//            Cloud
//                .shared
//                .archive
//                .map(\.entries)
//                .compactMap { [weak self] in
//                    $0.first { $0.id == self?.browser.entry.value }
//                }
//                .map(\.url)
//                .removeDuplicates()
//                .sink { [weak self] in
//                    self?.stringValue = $0
//                }
//                .store(in: &subs)
//            
//            browser.close.sink { [weak self] in
//                self?.stringValue = ""
//            }.store(in: &subs)
        }
        
        override func becomeFirstResponder() -> Bool {
            if !stringValue.isEmpty {
                currentEditor()?.selectedRange = .init(location: 0, length: stringValue.count)
            }
            return super.becomeFirstResponder()
        }
        
        override func textDidChange(_: Notification) {
//            browser.search.send(stringValue)
            session.filter.send((id: id, query: stringValue))
        }
        
        func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
            switch doCommandBy {
            case #selector(cancelOperation):
//                browser.search.send("")
                window!.makeFirstResponder(superview!)
            default: return false
            }
            return true
        }
        
        @objc private func search() {
            window?.makeFirstResponder(window?.contentView)
            session.filter.send((id: id, query: ""))
            
            let browse = tabber.items.value[state: id].browse
            cloud
                .browse(stringValue, id: browse) { [weak self] in
                    guard let id = self?.id else { return }
                    if browse == $0 {
    //                    if case .error = self?.wrapper.session.tab.state(id) {
    //                        self?.wrapper.session.tab.browse(id, $0)
    //                    }
                        session.load.send((id: id, access: $1))
                    } else {
                        tabber.browse(id, $0)
                    }
                }
            
            
            
            
//            if let id = browser.entry.value {
//                Cloud.shared.browse(id, stringValue) { [weak self] in
//                    switch $0 {
//                    case .navigate:
//                        self?.window?.makeFirstResponder(self?.window?.contentView)
//                    default: break
//                    }
//                    self?.browser.load.send()
//                }
//            } else {
//                Cloud.shared.browse(stringValue) { [weak self] in
//                    switch $0 {
//                    case .navigate:
//                        self?.window?.makeFirstResponder(self?.window?.contentView)
//                    default: break
//                    }
//                    self?.browser.entry.value = $1
//                }
//            }
        }
    }
}
