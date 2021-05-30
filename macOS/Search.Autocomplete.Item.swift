import AppKit

extension Search.Autocomplete {
    final class Item: NSView {
        let url: String
        
        required init?(coder: NSCoder) { nil }
        init(title: String, url: String) {
            self.url = url
            super.init(frame: .zero)
            
        }
    }
}
