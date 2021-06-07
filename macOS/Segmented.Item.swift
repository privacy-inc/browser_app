import AppKit

extension Segmented {
    final class Item: Control {
        private(set) weak var label: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            let label = Text()
            label.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .medium)
            label.stringValue = title
            self.label = label
            
            super.init(layer: false)
            addSubview(label)

            label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
}
