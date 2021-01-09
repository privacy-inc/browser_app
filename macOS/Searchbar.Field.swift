import AppKit
import Combine
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
            
            browser.page.sink { [weak self] in
                guard let url = $0?.url else { return }
                self?.stringValue = url.absoluteString
            }.store(in: &subs)
            
            browser.close.sink { [weak self] in
                self?.stringValue = ""
            }.store(in: &subs)
        }
        
        override func becomeFirstResponder() -> Bool {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let text = self?.stringValue else { return }
                self?.currentEditor()?.alignment = .left
                if !text.isEmpty {
                    self?.currentEditor()?.selectedRange = .init(location: 0, length: text.count)
                }
            }
            return super.becomeFirstResponder()
        }
        
        func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
            switch doCommandBy {
            case #selector(cancelOperation):
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
            Defaults.engine.browse(stringValue).map {
                switch $0 {
                case let .search(url):
                    browser.browse.send(url)
                case let .navigate(url):
                    browser.browse.send(url)
                    window?.makeFirstResponder(window?.contentView)
                }
            }
        }
    }
}
