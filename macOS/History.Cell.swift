import AppKit
import Combine
import Sleuth

extension History {
    final class Cell: NSView {
        var page: Page? {
            didSet {
                if let page = page {
                    layer!.borderColor = .clear
                    layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.03).cgColor
                    close.state = .on
                    
                    text.attributedStringValue = {
                        $0.append(.init(string: formatter.localizedString(for: page.date, relativeTo: .init()) + "\n", attributes: [
                                                .font : NSFont.systemFont(ofSize: 12, weight: .regular),
                                                .foregroundColor : NSColor.secondaryLabelColor]))

                        if !page.title.isEmpty {
                            $0.append(.init(string: page.title + "\n", attributes: [
                                                    .font : NSFont.systemFont(ofSize: 14, weight: .regular),
                                                    .foregroundColor : NSColor.labelColor]))
                        }
                        $0.append(.init(string: {
                            $0.count > 60
                                ? page.title.isEmpty
                                    ? $0
                                    : .init($0.prefix(57)) + "..."
                                : $0
                        } (page.url.absoluteString), attributes: [
                                                .font : NSFont.systemFont(ofSize: 12, weight: .regular),
                                                .foregroundColor : NSColor.tertiaryLabelColor]))
                        return $0
                    } (NSMutableAttributedString())
                } else {
                    text.attributedStringValue = .init()
                }
            }
        }
        
        private weak var text: Text!
        private weak var close: Control.Button!
        private weak var formatter: RelativeDateTimeFormatter!
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init(formatter: RelativeDateTimeFormatter) {
            super.init(frame: .zero)
            wantsLayer = true
            layer!.cornerRadius = 12
            layer!.borderWidth = 2
            self.formatter = formatter
            
            let text = Text()
            addSubview(text)
            self.text = text
            
            let close = Control.Button("xmark")
            close.layer!.cornerRadius = 15
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
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
            text.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -20).isActive = true
            
            close.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
            close.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
            close.widthAnchor.constraint(equalToConstant: 30).isActive = true
            close.heightAnchor.constraint(equalTo: close.widthAnchor).isActive = true
            
            addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .activeInActiveApp, .inVisibleRect], owner: self))
        }
        
        override func mouseEntered(with: NSEvent) {
            layer!.borderColor = NSColor.controlAccentColor.cgColor
        }
        
        override func mouseExited(with: NSEvent) {
            layer!.borderColor = .clear
        }
    }
}
