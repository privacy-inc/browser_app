import AppKit

extension Searchbar {
    final class Field: NSSearchField, NSSearchFieldDelegate {
        required init?(coder: NSCoder) { nil }
        init() {
            Self.cellClass = Cell.self
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
            menu.showsStateColumn = true
            let google = NSMenuItem(title: NSLocalizedString("Google", comment: ""), action: nil, keyEquivalent: "1")
            google.keyEquivalentModifierMask = [.command, .option, .shift]
            let ecosia = NSMenuItem(title: NSLocalizedString("Ecosia", comment: ""), action: nil, keyEquivalent: "2")
            ecosia.keyEquivalentModifierMask = [.command, .option, .shift]
            ecosia.state = .on
            let recents = NSMenuItem(title: NSLocalizedString("Recents", comment: ""), action: nil, keyEquivalent: "")
            recents.tag = NSSearchField.recentsMenuItemTag
            let clear = NSMenuItem(title: NSLocalizedString("Clear searches", comment: ""), action: nil, keyEquivalent: "")
            clear.tag = NSSearchField.clearRecentsMenuItemTag
            let empty = NSMenuItem(title: NSLocalizedString("No recent searches", comment: ""), action: nil, keyEquivalent: "")
            empty.tag = NSSearchField.noRecentsMenuItemTag
            menu.items = [google, ecosia, .separator(), recents, .separator(), clear, empty]
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
