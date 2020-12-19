import AppKit
import Sleuth

extension History {
    final class Cell: NSView {
        var item: Page? {
            didSet {
                title.stringValue = item?.title ?? ""
                subtitle.stringValue = item?.url.absoluteString ?? ""
            }
        }
        
        var index = 0
        private weak var title: Text!
        private weak var subtitle: Text!
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            wantsLayer = true
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            layer!.cornerRadius = 6
            
            let title = Text(.systemFont(ofSize: 14, weight: .medium))
            addSubview(title)
            self.title = title
            
            let subtitle = Text(.systemFont(ofSize: 12, weight: .light))
            subtitle.textColor = .secondaryLabelColor
            addSubview(subtitle)
            self.subtitle = subtitle
            
            title.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -14).isActive = true
            
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
            subtitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
            subtitle.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -14).isActive = true
        }
        
        func update(_ frame: CGRect) {
            ["bounds", "position"].forEach {
                let transition = CABasicAnimation(keyPath: $0)
                transition.duration = 0.3
                transition.timingFunction = .init(name: .easeOut)
                layer!.add(transition, forKey: $0)
            }
            self.frame = frame
        }
    }
}
