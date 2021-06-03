import AppKit
import Combine
import Sleuth

extension Window {
    final class Error: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID, browse: Int, error: Tab.Error) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            wantsLayer = true
            layer!.backgroundColor = NSColor.underPageBackgroundColor.cgColor
            layer!.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            let content = NSView()
            content.translatesAutoresizingMaskIntoConstraints = false
            addSubview(content)
            
            let icon = NSImageView(image: NSImage(systemSymbolName: "exclamationmark.triangle.fill", accessibilityDescription: nil)!)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.symbolConfiguration = .init(pointSize: 50, weight: .regular)
            icon.imageScaling = .scaleNone
            content.addSubview(icon)
            
            let domain = Text()
            domain.stringValue = error.domain
            domain.font = .preferredFont(forTextStyle: .headline)
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
                .sink {
                    cloud
                        .browse(error.url, id: browse) { _, _ in
                            tabber.browse(id, browse)
                        }
                }
                .store(in: &subs)
            content.addSubview(retry)
            
            let cancel = Option(icon: "xmark", title: "Cancel")
            cancel
                .click
                .sink {
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
                .store(in: &subs)
            content.addSubview(cancel)
            
            content.topAnchor.constraint(equalTo: topAnchor).isActive = true
            content.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            content.widthAnchor.constraint(equalToConstant: 300).isActive = true
            content.heightAnchor.constraint(equalToConstant: 300).isActive = true
            
            icon.topAnchor.constraint(equalTo: content.topAnchor, constant: 50).isActive = true
            icon.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
            
            domain.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20).isActive = true
            domain.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
            domain.rightAnchor.constraint(lessThanOrEqualTo: content.rightAnchor).isActive = true
            
            description.topAnchor.constraint(equalTo: domain.bottomAnchor, constant: 5).isActive = true
            description.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
            description.rightAnchor.constraint(lessThanOrEqualTo: content.rightAnchor).isActive = true
            
            retry.bottomAnchor.constraint(equalTo: cancel.topAnchor, constant: -10).isActive = true
            retry.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
            
            cancel.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
            cancel.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        }
    }
}
