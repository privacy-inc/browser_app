import AppKit
import Combine
import Archivable
import Sleuth

extension Searchbar {
    final class Field: NSTextField, NSTextFieldDelegate {
        override var canBecomeKeyView: Bool { true }
        
        private weak var browser: Browser!
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(browser: Browser) {
            self.browser = browser
            Self.cellClass = Cell.self
            super.init(frame: .zero)
            bezelStyle = .roundedBezel
            translatesAutoresizingMaskIntoConstraints = false
            font = .systemFont(ofSize: 13, weight: .regular)
            controlSize = .large
            delegate = self
            lineBreakMode = .byTruncatingMiddle
            target = self
            action = #selector(search)
            textColor = .labelColor
            isAutomaticTextCompletionEnabled = false
            
            Cloud
                .shared
                .archive
                .map(\.entries)
                .compactMap { [weak self] in
                    $0.first { $0.id == self?.browser.entry.value }
                }
                .map(\.url)
                .removeDuplicates()
                .sink { [weak self] in
                    self?.stringValue = $0
                }
                .store(in: &subs)
            
            browser.close.sink { [weak self] in
                self?.stringValue = ""
            }.store(in: &subs)
        }
        
        override func becomeFirstResponder() -> Bool {
            let text = stringValue
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.currentEditor()?.alignment = .left
                if !text.isEmpty {
                    self?.currentEditor()?.selectedRange = .init(location: 0, length: text.count)
                }
            }
            return super.becomeFirstResponder()
        }
        
        override func textDidChange(_: Notification) {
            browser.search.send(stringValue)
        }
        
        func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
            switch doCommandBy {
            case #selector(cancelOperation):
                browser.search.send("")
                window!.makeFirstResponder(superview!)
            default: return false
            }
            return true
        }
        
        func controlTextDidBeginEditing(_ obj: Notification) {
            currentEditor()?.alignment = .left
        }
        
        func controlTextDidEndEditing(_ obj: Notification) {
            currentEditor()?.alignment = .center
        }
        
        @objc private func search() {
            if let id = browser.entry.value {
                Cloud.shared.browse(id, stringValue) { [weak self] in
                    switch $0 {
                    case .navigate:
                        self?.window?.makeFirstResponder(self?.window?.contentView)
                    default: break
                    }
                    self?.browser.load.send()
                }
            } else {
                Cloud.shared.browse(stringValue) { [weak self] in
                    switch $0 {
                    case .navigate:
                        self?.window?.makeFirstResponder(self?.window?.contentView)
                    default: break
                    }
                    self?.browser.entry.value = $1
                }
            }
        }
    }
}
