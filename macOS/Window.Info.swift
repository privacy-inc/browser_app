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
            
            let text = Selectable()
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            contentViewController!.view.addSubview(text)
            
            switch page?.access {
            case let .remote(remote):
                let image = Image(icon: remote.secure ? "lock.fill" : "exclamationmark.triangle.fill")
                image.symbolConfiguration = .init(textStyle: .largeTitle)
                image.contentTintColor = .tertiaryLabelColor
                contentViewController!.view.addSubview(image)
                
                text.attributedStringValue = .make { string in
                    string.append(.make(remote.secure ? "Secure Connection" : "Site Not Secure",
                                        font: .font(style: .body, weight: .bold),
                                        color: .secondaryLabelColor,
                                        alignment: .center))
                    string.linebreak()
                    page
                        .map(\.access.short)
                        .map {
                            string.append(.make(remote.secure ? "Using an encrypted connection to \($0)" : "Connection to \($0) is NOT encrypted",
                                                font: .preferredFont(forTextStyle: .callout),
                                                color: .secondaryLabelColor,
                                                alignment: .center))
                        }

                    string.linebreak()
                    page
                        .map(\.title)
                        .map {
                            string.linebreak()
                            string.append(.make($0, font: .preferredFont(forTextStyle: .callout), color: .secondaryLabelColor))
                        }
                    
                    page
                        .map(\.access.value)
                        .map {
                            string.linebreak()
                            string.append(.make($0,
                                                font: .preferredFont(forTextStyle: .callout),
                                                color: .tertiaryLabelColor,
                                                lineBreak: .byCharWrapping))
                        }
                }
                
                image.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 40).isActive = true
                image.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
                
                text.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10).isActive = true
            case let .local(local):
                text.attributedStringValue = .make { string in
                    page
                        .map(\.title)
                        .map {
                            string.append(.make($0, font: .preferredFont(forTextStyle: .callout)))
                            string.linebreak()
                        }
                    
                    string.append(.make(local.path,
                                        font: .preferredFont(forTextStyle: .callout),
                                        color: .secondaryLabelColor,
                                        lineBreak: .byCharWrapping))
                }
                
                text.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 40).isActive = true
            default:
                break
            }
            
            let copy = Control.Squircle(icon: "doc.on.doc")
            subscription = copy
                .click
                .sink { [weak self] in
                    page
                        .map(\.access.value)
                        .map {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString($0, forType: .string)
                            Toast.show(message: .init(title: "URL copied", icon: "doc.on.doc.fill"))
                        }
                    self?.close()
                }
            contentViewController!.view.addSubview(copy)
            
            text.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
            text.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor, constant: -30).isActive = true
            
            copy.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 10).isActive = true
            copy.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor, constant: -30).isActive = true
            copy.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -30).isActive = true
        }
    }
}
