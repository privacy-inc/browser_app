import AppKit

extension Searchbar {
    final class Field: NSTextField, NSTextFieldDelegate {
        required init?(coder: NSCoder) { nil }
        init(browser: Browser) {
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
        
        func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
            switch doCommandBy {
            case #selector(cancelOperation):
                window!.makeFirstResponder(superview!)
            default: return false
            }
            return true
        }
        
        @objc private func search() {
            print(stringValue)
        }
    }
}
