import AppKit
import Sleuth

extension Autocomplete {
    final class Cell: NSView {
        var highlighted = false {
            didSet {
                background.isHidden = !highlighted
            }
        }
        
        let filtered: Filtered
        private weak var background: Background!
        
        required init?(coder: NSCoder) { nil }
        init(filtered: Filtered) {
            self.filtered = filtered
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let background = Background()
            self.background = background
            addSubview(background)
            
            let icon = Icon()
            icon.domain.send(filtered.short)
            addSubview(icon)
            
            let text = Text()
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            text.attributedStringValue = .make {
                if !filtered.title.isEmpty {
                    $0.append(.make(filtered.title,
                                    font: .preferredFont(forTextStyle: .callout),
                                    color: .labelColor))
                }
                if !filtered.url.isEmpty {
                    $0.append(.make((filtered.title.isEmpty ? "" : " :") + filtered.short,
                                    font: .preferredFont(forTextStyle: .callout),
                                    color: .tertiaryLabelColor,
                                    lineBreak: .byTruncatingTail))
                }
            }
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 10).isActive = true
            
            background.topAnchor.constraint(equalTo: topAnchor).isActive = true
            background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            text.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10).isActive = true
        }
    }
}

private final class Background: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer = Layer()
        wantsLayer = true
        layer!.backgroundColor =  NSColor.quaternaryLabelColor.cgColor
        layer!.cornerRadius = 6
        isHidden = true
    }
    
    override var allowsVibrancy: Bool {
        true
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
}
