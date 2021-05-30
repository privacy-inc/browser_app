import AppKit
import Sleuth

extension Search.Autocomplete {
    final class Cell: NSView {
        let filtered: Filtered
        
        required init?(coder: NSCoder) { nil }
        init(filtered: Filtered) {
            self.url = url
            super.init(frame: .zero)
            
        }
    }
}
