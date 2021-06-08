import AppKit

extension Trackers {
    final class Item: NSView {
        required init?(coder: NSCoder) { nil }
        init(name: String, count: [Date]) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let text = Selectable()
            text.attributedStringValue = .make { string in
                string.append(.make(name, font: .preferredFont(forTextStyle: .callout)))
                string.linebreak()
                count
                    .last
                    .map {
                        string.append(.make(RelativeDateTimeFormatter().string(from: $0), font: .preferredFont(forTextStyle: .callout), color: .secondaryLabelColor))
                    }
            }
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(text)
            
            let counter = Text()
            counter.stringValue = session.decimal.string(from: .init(value: count.count)) ?? ""
            counter.font = .monoDigit(style: .title2, weight: .regular)
            addSubview(counter)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 10).isActive = true
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: counter.leftAnchor, constant: -10).isActive = true
            
            counter.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            counter.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
}
