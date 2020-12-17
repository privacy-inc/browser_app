import AppKit
import Sleuth

extension Searchbar {
    final class Field: NSTextField, NSTextFieldDelegate {
        private weak var browser: Browser!
        override var acceptsFirstResponder: Bool { true }
        override var canBecomeKeyView: Bool { true }
        
        required init?(coder: NSCoder) { nil }
        init(browser: Browser) {
            self.browser = browser
            Self.cellClass = Cell.self
            super.init(frame: .zero)
            bezelStyle = .roundedBezel
            translatesAutoresizingMaskIntoConstraints = false
            font = .systemFont(ofSize: 14)
            controlSize = .large
            delegate = self
            lineBreakMode = .byTruncatingMiddle
            target = self
            action = #selector(search)
        }
        
        override func becomeFirstResponder() -> Bool {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.currentEditor()?.selectedRange = .init(location: 0, length: self?.stringValue.count ?? 0)
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
