import AppKit
import Sleuth

extension Search.Autocomplete {
    final class Cell: NSView {
        let filtered: Filtered
        
        required init?(coder: NSCoder) { nil }
        init(filtered: Filtered) {
            self.filtered = filtered
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let text = Text()
            text.attributedStringValue = .make {
                if !filtered.title.isEmpty {
                    $0.add(filtered.title,
                           font: .preferredFont(forTextStyle: .callout),
                           color: .labelColor)
                }
                if !filtered.url.isEmpty {
                    if !filtered.title.isEmpty {
                        $0.linebreak()
                    }
                    $0.add(filtered.url,
                           font: .preferredFont(forTextStyle: .footnote),
                           color: .secondaryLabelColor)
                }
            }
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 5).isActive = true
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -5).isActive = true
        }
    }
}
