import AppKit

extension NSAlert {
    class func delete(title: String, icon: String, completion: () -> Void) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.icon = NSImage(systemSymbolName: icon, accessibilityDescription: nil)
        alert.messageText = title
        
        let delete = alert.addButton(withTitle: NSLocalizedString("Delete", comment: ""))
        let cancel = alert.addButton(withTitle: NSLocalizedString("Cancel", comment: ""))
        delete.keyEquivalent = "\r"
        cancel.keyEquivalent = "\u{1b}"
        if alert.runModal().rawValue == delete.tag {
            completion()
        }
    }
}
