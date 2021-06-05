import AppKit

extension Segmented {
    final class Item: Control {
        private(set) weak var label: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            super.init(layer: false)
            
            let label = Text()
            label.font = .systemFont(ofSize: 12, weight: .bold)
            label.stringValue = title
            addSubview(label)
            self.label = label
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
}
