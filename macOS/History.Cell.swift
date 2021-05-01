import AppKit
import Combine
import Sleuth

extension History {
    final class Cell: NSView {
        var page: Map.Page? {
            didSet {
                if let page = page {
                    layer!.borderColor = .clear
                    layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.03).cgColor
                    close.state = .on
                    text.attributedStringValue = page.text
                } else {
                    text.attributedStringValue = .init()
                }
            }
        }
        
        private weak var text: Text!
        private weak var close: Button!
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            wantsLayer = true
            layer!.cornerRadius = 10
            layer!.borderWidth = 2
            
            let text = Text()
            addSubview(text)
            self.text = text
            
            let close = Button(icon: "xmark")
            close.layer!.cornerRadius = 15
            sub = close.click.sink { [weak self] in
                guard let page = self?.page else { return }
                NSAnimationContext.runAnimationGroup {
                    $0.duration = 0.5
                    $0.allowsImplicitAnimation = true
                    self?.layer!.backgroundColor = NSColor.systemPink.withAlphaComponent(0.6).cgColor
                } completionHandler: {
                    Synch.cloud.remove(page.entry)
                }
            }
            addSubview(close)
            self.close = close
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.history.margin).isActive = true
            text.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Metrics.history.margin).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: Metrics.history.margin).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -Metrics.history.margin).isActive = true
            
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
