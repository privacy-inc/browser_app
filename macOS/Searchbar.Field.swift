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
            
            let menu = NSMenu()
            let recents = NSMenuItem(title: "Recents", action: nil, keyEquivalent: "")
            recents.tag = NSSearchField.recentsMenuItemTag
            let clear = NSMenuItem(title: NSLocalizedString("Clear searches", comment: ""), action: nil, keyEquivalent: "")
            clear.tag = NSSearchField.clearRecentsMenuItemTag
            let empty = NSMenuItem(title: NSLocalizedString("No recent searches", comment: ""), action: nil, keyEquivalent: "")
            empty.tag = NSSearchField.noRecentsMenuItemTag
            menu.addItem(recents)
            menu.addItem(.separator())
            menu.addItem(clear)
            menu.addItem(empty)
            recentsAutosaveName = "recent_searches"
            searchMenuTemplate = menu
            
//            (cell as! NSSearchFieldCell).searchButtonCell = NSButtonCell(imageCell: NSImage(systemSymbolName: "lock.fill", accessibilityDescription: nil))
//            (cell as! NSSearchFieldCell).cancelButtonCell = NSButtonCell(imageCell: NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: nil))
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
