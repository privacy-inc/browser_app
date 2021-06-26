import AppKit
import Combine
import Sleuth

extension Window {
    final class Error: NSView {
        private var subs = Set<AnyCancellable>()
        private let id: UUID
        private let browse: Int
        private let error: Tab.Error
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID, browse: Int, error: Tab.Error) {
            self.id = id
            self.browse = browse
            self.error = error
            
            super.init(frame: .zero)
            let content = NSView()
            content.translatesAutoresizingMaskIntoConstraints = false
            addSubview(content)
            
            let icon = Image(icon: "exclamationmark.triangle.fill")
            icon.symbolConfiguration = .init(pointSize: 50, weight: .regular)
            icon.imageScaling = .scaleNone
            icon.contentTintColor = .tertiaryLabelColor
            content.addSubview(icon)
            
            let domain = Text()
            domain.stringValue = error.domain
            domain.font = .preferredFont(forTextStyle: .title3)
            domain.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            content.addSubview(domain)
            
            let description = Text()
            description.stringValue = error.description
            description.font = .preferredFont(forTextStyle: .body)
            description.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            description.textColor = .secondaryLabelColor
            content.addSubview(description)
            
            let retry = Option(icon: "gobackward", title: "Try again")
            retry
                .click
                .sink { [weak self] in
                    self?.tryAgain()
                }
                .store(in: &subs)
            content.addSubview(retry)
            
            let cancel = Option(icon: "xmark.circle.fill", title: "Cancel")
            cancel
                .click
                .sink { [weak self] in
                    self?.cancel()
                }
                .store(in: &subs)
            content.addSubview(cancel)
            
            content.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            content.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            content.widthAnchor.constraint(equalToConstant: 300).isActive = true
            content.bottomAnchor.constraint(equalTo: cancel.bottomAnchor).isActive = true
            
            icon.topAnchor.constraint(equalTo: content.topAnchor, constant: 50).isActive = true
            icon.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
            
            domain.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20).isActive = true
            domain.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
            domain.rightAnchor.constraint(lessThanOrEqualTo: content.rightAnchor).isActive = true
            
            description.topAnchor.constraint(equalTo: domain.bottomAnchor, constant: 5).isActive = true
            description.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
            description.rightAnchor.constraint(lessThanOrEqualTo: content.rightAnchor).isActive = true
            
            retry.topAnchor.constraint(equalTo: description.bottomAnchor, constant: 50).isActive = true
            retry.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
            
            cancel.topAnchor.constraint(equalTo: retry.bottomAnchor).isActive = true
            cancel.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        }
        
        override func cancelOperation(_: Any?) {
            cancel()
        }
        
        override func mouseDown(with: NSEvent) {
            super.mouseDown(with: with)
            if with.clickCount == 1 {
                window?.makeFirstResponder(self)
            }
        }
        
        @objc func tryAgain() {
            cloud
                .browse(error.url, browse: browse) { [weak self] in
                    guard
                        let id = self?.id,
                        let browse = self?.browse
                    else { return }
                    tabber.browse(id, browse)
                    session.load.send((id: id, access: $1))
                }
        }
        
        private func cancel() {
            guard let web = tabber.items.value[web: id] as? Web else { return }
            if let url = web.url {
                cloud.update(browse, url: url)
                cloud.update(browse, title: web.title ?? "")
                tabber.dismiss(id)
            } else {
                NSApp.newTab()
                session.close.send(id)
            }
        }
    }
}
