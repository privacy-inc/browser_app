import AppKit
import Combine

extension Window {
    final class Info: NSPopover {
        private var subscription: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            super.init()
            behavior = .transient
            contentSize = .init(width: 300, height: 200)
            contentViewController = .init()
            contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
            
            let page = tabber
                .items
                .value[state: id]
                .browse
                .map(cloud.archive.value.page)
            let secure = page?.secure ?? false
            let domain = page?.access.domain ?? ""
            
            let image = Image(icon: secure ? "lock.fill" : "exclamationmark.triangle.fill")
            image.symbolConfiguration = .init(textStyle: .largeTitle)
            image.contentTintColor = secure ? .controlAccentColor : .systemPink
            contentViewController!.view.addSubview(image)
            
            let message = Text()
            message.isSelectable = true
            message.stringValue = secure ? "Secure Connection" : "Site Not Secure"
            message.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .bold)
            contentViewController!.view.addSubview(message)
            
            let description = Text()
            description.isSelectable = true
            description.stringValue = secure ? "Using an encrypted connection to \(domain)" : "Connection to \(domain) is NOT encrypted"
            description.font = .preferredFont(forTextStyle: .callout)
            description.textColor = .secondaryLabelColor
            description.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            contentViewController!.view.addSubview(description)
            
            let title = Text()
            title.stringValue = page?.title ?? ""
            title.font = .preferredFont(forTextStyle: .callout)
            title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            title.isSelectable = true
            contentViewController!.view.addSubview(title)
            
            let url = Text()
            url.stringValue = page?.access.string ?? ""
            url.font = .preferredFont(forTextStyle: .callout)
            url.textColor = .secondaryLabelColor
            url.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            url.isSelectable = true
            contentViewController!.view.addSubview(url)
            
            let copy = Control.Squircle(icon: "doc.on.doc")
            subscription = copy
                .click
                .sink { [weak self] in
                    page
                        .map(\.access.string)
                        .map {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString($0, forType: .string)
                            Toast.show(message: .init(title: "URL copied", icon: "doc.on.doc"))
                        }
                    self?.close()
                }
            contentViewController!.view.addSubview(copy)
            
            image.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 40).isActive = true
            image.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
            
            message.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10).isActive = true
            message.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
            
            description.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 2).isActive = true
            description.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
            description.rightAnchor.constraint(lessThanOrEqualTo: contentViewController!.view.rightAnchor, constant: -30).isActive = true
            
            title.topAnchor.constraint(equalTo: description.bottomAnchor, constant: 20).isActive = true
            title.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: contentViewController!.view.rightAnchor, constant: -30).isActive = true
            
            url.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2).isActive = true
            url.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
            url.rightAnchor.constraint(lessThanOrEqualTo: contentViewController!.view.rightAnchor, constant: -30).isActive = true
            
            copy.topAnchor.constraint(equalTo: url.bottomAnchor, constant: 10).isActive = true
            copy.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor, constant: -30).isActive = true
            copy.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -30).isActive = true
        }
    }
}
