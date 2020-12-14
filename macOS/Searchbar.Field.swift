import AppKit

extension Searchbar {
    final class Field: NSSearchField, NSSearchFieldDelegate {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            bezelStyle = .roundedBezel
            translatesAutoresizingMaskIntoConstraints = false
            font = .systemFont(ofSize: 14)
            controlSize = .large
            sendsWholeSearchString = true
            sendsSearchStringImmediately = true
            delegate = self
            lineBreakMode = .byTruncatingMiddle
            (cell as! NSSearchFieldCell).cancelButtonCell = nil
        }
        
        func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
            switch doCommandBy {
            case #selector(cancelOperation):
                window!.makeFirstResponder(superview!)
            default: return false
            }
            return true
        }
    }
}
