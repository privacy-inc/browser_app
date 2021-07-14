import AppKit
import Sleuth

extension Autocomplete {
    final class Cell: NSView {
        var highlighted = false {
            didSet {
                layer!.backgroundColor = highlighted ? NSColor.controlBackgroundColor.cgColor : .clear
            }
        }
        
        let filtered: Filtered
        
        required init?(coder: NSCoder) { nil }
        init(filtered: Filtered) {
            self.filtered = filtered
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            wantsLayer = true
            layer!.cornerRadius = 6
            
            let text = Text()
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            text.attributedStringValue = .make {
                if !filtered.title.isEmpty {
                    $0.append(.make(filtered.title,
                                    font: .preferredFont(forTextStyle: .callout),
                                    color: .labelColor))
                }
                if !filtered.url.isEmpty {
                    if !filtered.title.isEmpty {
                        $0.linebreak()
                    }
                    $0.append(.make(filtered.short,
                                    font: .preferredFont(forTextStyle: .callout),
                                    color: .tertiaryLabelColor,
                                    lineBreak: .byTruncatingTail))
                }
            }
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 10).isActive = true
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10).isActive = true
        }
    }
}
