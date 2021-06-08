import AppKit
import Sleuth

extension Search.Autocomplete {
    final class Cell: NSView {
        var highlighted = false {
            didSet {
                layer!.backgroundColor = highlighted ? NSColor.systemBlue.cgColor : .clear
                render(highlight: highlighted)
            }
        }
        
        let filtered: Filtered
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(filtered: Filtered) {
            self.filtered = filtered
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            wantsLayer = true
            layer!.cornerRadius = 4
            
            let text = Text()
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(text)
            self.text = text
            
            render(highlight: false)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 5).isActive = true
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -5).isActive = true
        }
        
        private func render(highlight: Bool) {
            text.attributedStringValue = .make {
                if !filtered.title.isEmpty {
                    $0.append(.make(filtered.title,
                                    font: .preferredFont(forTextStyle: .callout),
                                    color: highlight ? .white : .labelColor))
                }
                if !filtered.url.isEmpty {
                    if !filtered.title.isEmpty {
                        $0.linebreak()
                    }
                    $0.append(.make(filtered.url,
                                    font: .preferredFont(forTextStyle: .footnote),
                                    color: highlight ? .white : .secondaryLabelColor,
                                    lineBreak: .byCharWrapping))
                }
            }
        }
    }
}
