import AppKit
import Combine

extension Window {
    final class Info: NSPopover {
        private var subscription: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            super.init()
            behavior = .semitransient
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
            image.contentTintColor = .labelColor
            contentViewController!.view.addSubview(image)
            
            let text = Selectable()
            text.attributedStringValue = .make { string in
                string.append(.make(secure ? "Secure Connection" : "Site Not Secure",
                                    font: .font(style: .body, weight: .bold),
                                    alignment: .center))
                string.linebreak()
                string.append(.make(secure ? "Using an encrypted connection to \(domain)" : "Connection to \(domain) is NOT encrypted",
                                    font: .preferredFont(forTextStyle: .callout),
                                    color: .secondaryLabelColor))
                string.linebreak()
                page
                    .map(\.title)
                    .map {
                        string.linebreak()
                        string.append(.make($0, font: .preferredFont(forTextStyle: .callout)))
                    }
                
                page
                    .map(\.access.string)
                    .map {
                        string.linebreak()
                        string.append(.make($0,
                                            font: .preferredFont(forTextStyle: .callout),
                                            color: .secondaryLabelColor,
                                            lineBreak: .byCharWrapping))
                    }
            }
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            contentViewController!.view.addSubview(text)
            
            let copy = Control.Squircle(icon: "doc.on.doc")
            subscription = copy
                .click
                .sink { [weak self] in
                    page
                        .map(\.access.string)
                        .map {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString($0, forType: .string)
                            Toast.show(message: .init(title: "URL copied", icon: "doc.on.doc.fill"))
                        }
                    self?.close()
                }
            contentViewController!.view.addSubview(copy)
            
            image.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 40).isActive = true
            image.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
            
            text.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10).isActive = true
            text.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
            text.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor, constant: -30).isActive = true
            
            copy.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 10).isActive = true
            copy.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor, constant: -30).isActive = true
            copy.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -30).isActive = true
        }
    }
}
