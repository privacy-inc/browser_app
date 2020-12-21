import AppKit
import Combine
import Sleuth

extension History {
    final class Cell: NSView {
        var page: Page? {
            didSet {
                text.attributedStringValue = page.map {
                    let string = NSMutableAttributedString()
                    string.append(.init(string: formatter.localizedString(for: $0.date, relativeTo: .init()) + "\n\n", attributes: [
                                            .font : NSFont.systemFont(ofSize: 12, weight: .medium),
                                            .foregroundColor : NSColor.tertiaryLabelColor]))
                    if !$0.title.isEmpty {
                        string.append(.init(string: $0.title + "\n", attributes: [
                                                .font : NSFont.systemFont(ofSize: 14, weight: .medium),
                                                .foregroundColor : NSColor.labelColor]))
                    }
                    string.append(.init(string: $0.url.absoluteString, attributes: [
                                            .font : NSFont.systemFont(ofSize: 12, weight: .light),
                                            .foregroundColor : NSColor.secondaryLabelColor]))
                    return string
                } ?? .init()
            }
        }
        
        override var frame: NSRect {
            willSet {
                ["bounds", "position"].forEach {
                    let transition = CABasicAnimation(keyPath: $0)
                    transition.duration = 0.3
                    transition.timingFunction = .init(name: .easeOut)
                    layer!.add(transition, forKey: $0)
                }
            }
        }
        
        private weak var text: Text!
        private weak var formatter: RelativeDateTimeFormatter!
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init(formatter: RelativeDateTimeFormatter) {
            super.init(frame: .zero)
            wantsLayer = true
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            layer!.cornerRadius = 10
            self.formatter = formatter
            
            let text = Text()
            addSubview(text)
            self.text = text
            
            let close = Control.Button("xmark")
            sub = close.click.sink { [weak self] in
                guard let page = self?.page else { return }
                FileManager.delete(page)
                (NSApp as! App).refresh()
            }
            addSubview(close)
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
            text.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -16).isActive = true
            
            close.topAnchor.constraint(equalTo: topAnchor).isActive = true
            close.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            close.widthAnchor.constraint(equalToConstant: 40).isActive = true
            close.heightAnchor.constraint(equalTo: close.widthAnchor).isActive = true
            
            addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .activeInActiveApp, .inVisibleRect], owner: self))
        }
        
        override func mouseEntered(with: NSEvent) {
            layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.5).cgColor
        }
        
        override func mouseExited(with: NSEvent) {
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
        }
    }
}
