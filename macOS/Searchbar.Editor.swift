import AppKit

extension Searchbar {
    final class Editor: NSTextView {
        
        override func paste(_ sender: Any?) {
            let clean = {
                $0.replacingOccurrences(of: "\n", with: "")
            } ((NSPasteboard.general.string(forType: .string) ?? "").trimmingCharacters(in: .whitespacesAndNewlines))
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(clean, forType: .string)
            super.paste(sender)
        }
    }
}
