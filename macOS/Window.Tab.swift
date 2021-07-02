import AppKit
import Combine

extension Window {
    final class Tab: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            super.init(frame: .zero)
            
            let container = NSView()
            container.translatesAutoresizingMaskIntoConstraints = false
            addSubview(container)
            
            let icon = NSImageView(image: NSImage(named: "favicon")!)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.imageScaling = .scaleProportionallyUpOrDown
            container.addSubview(icon)
            
            let title = Text()
            title.font = .systemFont(ofSize: 12, weight: .regular)
            title.textColor = .labelColor
            title.stringValue = NSLocalizedString("Privacy", comment: "")
            title.maximumNumberOfLines = 1
            title.lineBreakMode = .byTruncatingTail
            container.addSubview(title)
            
            cloud
                .archive
                .combineLatest(tabber
                                .items
                                .map {
                                    $0[state: id]
                                        .browse
                                }
                                .compactMap {
                                    $0
                                }
                                .removeDuplicates())
                .map {
                    $0.0
                        .page($0.1)
                        .title
                }
                .filter {
                    !$0.isEmpty
                }
                .removeDuplicates()
                .sink {
                    title.stringValue = $0
                }
                .store(in: &subs)
            
            widthAnchor.constraint(equalToConstant: 10000).isActive = true
            
            container.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            container.topAnchor.constraint(equalTo: topAnchor).isActive = true
            container.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            container.rightAnchor.constraint(equalTo: title.rightAnchor).isActive = true
            
            icon.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
            icon.topAnchor.constraint(equalTo: container.topAnchor, constant: 5).isActive = true
            icon.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5).isActive = true
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
            
            title.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
            title.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
            title.widthAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        }
        
        override func hitTest(_: NSPoint) -> NSView? {
            nil
        }
    }
}
