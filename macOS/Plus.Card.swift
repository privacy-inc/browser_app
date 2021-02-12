import AppKit
import Combine

extension Plus {
    final class Card: NSWindow {
        private var sub: AnyCancellable?
        
        init(title: String, message: String, action: (() -> Void)?) {
            super.init(contentRect: .init(x: 0, y: 0, width: 600, height: 400),
                       styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
            toolbar = .init()
            titlebarAppearsTransparent = true
            collectionBehavior = .fullScreenNone
            isReleasedWhenClosed = false
            center()
            self.title = title
            
            let text = Text()
            text.stringValue = message
            text.font = .systemFont(ofSize: 14, weight: .regular)
            text.textColor = .secondaryLabelColor
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            contentView!.addSubview(text)
            
            let accept = Capsule(title: NSLocalizedString("Accept", comment: ""))
            sub = accept.click.sink { [weak self] in
                self?.close()
                action?()
            }
            contentView!.addSubview(accept)
            
            text.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor, constant: 40).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: contentView!.safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
            
            accept.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -40).isActive = true
            accept.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
            accept.widthAnchor.constraint(equalToConstant: 150).isActive = true
        }
    }
}
