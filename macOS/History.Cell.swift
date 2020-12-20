import AppKit
import Sleuth

extension History {
    final class Cell: NSView {
        var item: Page? {
            didSet {
                text.attributedStringValue = item.map {
                    let string = NSMutableAttributedString()
                    if !$0.title.isEmpty {
                        string.append(.init(string: $0.title + "\n", attributes: [
                                                .font : NSFont.systemFont(ofSize: 14, weight: .medium),
                                                .foregroundColor : NSColor.labelColor]))
                    }
                    string.append(.init(string: $0.url.absoluteString + "\n", attributes: [
                                            .font : NSFont.systemFont(ofSize: 12, weight: .light),
                                            .foregroundColor : NSColor.secondaryLabelColor]))
                    formatter.string(from: $0.date, to: .init()).map {
                        string.append(.init(string: $0, attributes: [
                                                .font : NSFont.systemFont(ofSize: 12, weight: .light),
                                                .foregroundColor : NSColor.secondaryLabelColor]))
                    }
                    return string
                } ?? .init()
            }
        }
        
        var index = 0
        private weak var text: Text!
        private weak var formatter: DateComponentsFormatter!
        
        required init?(coder: NSCoder) { nil }
        init(formatter: DateComponentsFormatter) {
            super.init(frame: .zero)
            wantsLayer = true
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            layer!.cornerRadius = 8
            self.formatter = formatter
            
            let text = Text()
            addSubview(text)
            self.text = text
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
            text.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -16).isActive = true
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
