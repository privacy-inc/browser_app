import AppKit

extension Trackers {
    final class Item: NSView {
        required init?(coder: NSCoder) { nil }
        init(name: String, count: [Date]) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let textName = Text()
            textName.isSelectable = true
            textName.stringValue = name
            textName.font = .preferredFont(forTextStyle: .callout)
            textName.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(textName)
            
            let textSince = Text()
            textSince.isSelectable = true
            textSince.stringValue = name
            textSince.font = .preferredFont(forTextStyle: .callout)
            textSince.textColor = .secondaryLabelColor
            count
                .last
                .map {
                    textSince.stringValue = RelativeDateTimeFormatter().string(from: $0)
                }
            
            addSubview(textSince)
            
            let textCount = Text()
            textCount.isSelectable = true
            textCount.stringValue = session.decimal.string(from: .init(value: count.count)) ?? ""
            textCount.font = .monospacedDigitSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .regular)
            addSubview(textCount)
            
            bottomAnchor.constraint(equalTo: textSince.bottomAnchor, constant: 10).isActive = true
            
            textName.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            textName.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            textName.rightAnchor.constraint(lessThanOrEqualTo: textCount.leftAnchor, constant: -10).isActive = true
            
            textSince.topAnchor.constraint(equalTo: textName.bottomAnchor, constant: 2).isActive = true
            textSince.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            
            textCount.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            textCount.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
}
