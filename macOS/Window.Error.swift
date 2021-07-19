import AppKit
import Combine
import Sleuth

extension Window {
    final class Error: NSVisualEffectView {
        private var subs = Set<AnyCancellable>()
        private let id: UUID
        private let browse: Int
        private let session: Session
        
        required init?(coder: NSCoder) { nil }
        init(session: Session, id: UUID, browse: Int, error: Sleuth.Tab.Error) {
            self.id = id
            self.browse = browse
            self.session = session
            
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            material = .popover
            state = .active
            
            let content = NSView()
            content.translatesAutoresizingMaskIntoConstraints = false
            addSubview(content)
            
            let icon = Image(icon: "exclamationmark.triangle.fill")
            icon.symbolConfiguration = .init(pointSize: 50, weight: .regular)
            icon.imageScaling = .scaleNone
            icon.contentTintColor = .quaternaryLabelColor
            content.addSubview(icon)
            
            let text = Selectable()
            text.attributedStringValue = .make {
                $0.append(.make(error.domain, font: .preferredFont(forTextStyle: .title3), color: .secondaryLabelColor))
                $0.linebreak()
                $0.append(.make(error.description, font: .preferredFont(forTextStyle: .body), color: .secondaryLabelColor))
            }
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            content.addSubview(text)
            
            let retry = Option(icon: "gobackward", title: "Try again")
            retry
                .click
                .sink { [weak self] in
                    cloud
                        .browse(error.url, browse: browse) { [weak self] in
                            self?
                                .session
                                .tab
                                .browse(id, browse)
                            self?
                                .session
                                .load
                                .send((id: id, access: $1))
                        }
                }
                .store(in: &subs)
            content.addSubview(retry)
            
            let cancel = Option(icon: "xmark", title: "Cancel")
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
            
            text.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20).isActive = true
            text.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: content.rightAnchor).isActive = true
            
            retry.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 50).isActive = true
            retry.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
            
            cancel.topAnchor.constraint(equalTo: retry.bottomAnchor, constant: 5).isActive = true
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
        
        private func cancel() {
            guard let web = session.tab.items.value[web: id] as? Web else { return }
            if let url = web.url {
                cloud
                    .update(browse, url: url)
                cloud
                    .update(browse, title: web.title ?? "")
                session
                    .tab
                    .dismiss(id)
            } else {
                session
                    .close
                    .send(id)
                session
                    .plus
                    .send()
            }
        }
    }
}
