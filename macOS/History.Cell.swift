import AppKit
import Combine
import Sleuth

extension History {
    final class Cell: NSView {
        var page: Page? {
            didSet {
                text.attributedStringValue = page.map {
                    date.stringValue = formatter.localizedString(for: $0.date, relativeTo: .init())
                    
                    let string = NSMutableAttributedString()
                    if !$0.title.isEmpty {
                        string.append(.init(string: $0.title + "\n", attributes: [
                                                .font : NSFont.systemFont(ofSize: 16, weight: .medium),
                                                .foregroundColor : NSColor.labelColor]))
                    }
                    string.append(.init(string: $0.url.absoluteString, attributes: [
                                            .font : NSFont.systemFont(ofSize: 12, weight: .regular),
                                            .foregroundColor : NSColor.secondaryLabelColor]))
                    return string
                } ?? .init()
            }
        }
        
        private weak var text: Text!
        private weak var date: Text!
        private weak var close: Control.Button!
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
            
            let date = Text()
            date.textColor = .secondaryLabelColor
            date.font = .systemFont(ofSize: 14, weight: .regular)
            addSubview(date)
            self.date = date
            
            let close = Control.Button("xmark")
            sub = close.click.sink { [weak self] in
                guard let page = self?.page else { return }
                NSAnimationContext.runAnimationGroup {
                    $0.duration = 0.5
                    $0.allowsImplicitAnimation = true
                    self?.layer!.backgroundColor = NSColor.systemPink.withAlphaComponent(0.6).cgColor
                } completionHandler: {
                    FileManager.delete(page)
                    (NSApp as! App).refresh()
                }
            }
            addSubview(close)
            self.close = close
            
            date.centerYAnchor.constraint(equalTo: close.centerYAnchor).isActive = true
            date.rightAnchor.constraint(equalTo: close.leftAnchor, constant: -5).isActive = true
            
            text.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 16).isActive = true
            text.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -16).isActive = true
            
            close.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
            close.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
            close.widthAnchor.constraint(equalToConstant: 30).isActive = true
            close.heightAnchor.constraint(equalTo: close.widthAnchor).isActive = true
            
            addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .activeInActiveApp, .inVisibleRect], owner: self))
        }
        
        func dequeue() {
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            close.state = .on
        }
        
        override func mouseEntered(with: NSEvent) {
            layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.5).cgColor
        }
        
        override func mouseExited(with: NSEvent) {
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
        }
    }
}
