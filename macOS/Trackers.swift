import AppKit
import Combine
import Sleuth

final class Trackers: NSWindow {
    private weak var scroll: Scroll!
    private var sub: AnyCancellable?
    private let formatter = NumberFormatter()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 400, height: 320),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
        toolbar = .init()
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        title = NSLocalizedString("Trackers blocked", comment: "")
        center()
        formatter.numberStyle = .decimal
        
        let scroll = Scroll()
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        contentView!.addSubview(scroll)
        self.scroll = scroll
        
        scroll.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.rightAnchor).isActive = true
        scroll.right.constraint(equalTo: contentView!.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        sub = (NSApp as! App).blocked.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.refresh()
        }
        refresh()
    }
    
    private func refresh() {
        scroll.views.forEach { $0.removeFromSuperview() }
        let blocked = Share.blocked
        
        let icon = NSImageView(image: NSImage(systemSymbolName: "shield.lefthalf.fill", accessibilityDescription: nil)!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.symbolConfiguration = .init(textStyle: .largeTitle, scale: .large)
        icon.contentTintColor = .labelColor
        scroll.add(icon)
        
        let count = Text()
        count.stringValue = formatter.string(from: .init(value: blocked.count))!
        count.font = .monospacedSystemFont(ofSize: 36, weight: .bold)
        scroll.add(count)
        
        icon.leftAnchor.constraint(equalTo: scroll.left, constant: 40).isActive = true
        icon.centerYAnchor.constraint(equalTo: count.centerYAnchor).isActive = true
        
        count.topAnchor.constraint(equalTo: scroll.top, constant: 20).isActive = true
        count.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 10).isActive = true
        var top = count.bottomAnchor
        
        blocked.forEach {
            let text = Text()
            text.isSelectable = true
            text.stringValue = $0
            text.maximumNumberOfLines = 1
            text.font = .systemFont(ofSize: 14, weight: .regular)
            text.textColor = .secondaryLabelColor
            scroll.add(text)
            
            if top != count.bottomAnchor {
                let separator = NSView()
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.wantsLayer = true
                separator.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.08).cgColor
                
                scroll.add(separator)
                
                separator.topAnchor.constraint(equalTo: top, constant: 10).isActive = true
                separator.leftAnchor.constraint(equalTo: scroll.left, constant: 40).isActive = true
                separator.rightAnchor.constraint(lessThanOrEqualTo: scroll.right, constant: -40).isActive = true
                separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                top = separator.bottomAnchor
                text.topAnchor.constraint(equalTo: top, constant: 10).isActive = true
            } else {
                text.topAnchor.constraint(equalTo: top, constant: 20).isActive = true
            }
            
            text.leftAnchor.constraint(equalTo: scroll.left, constant: 40).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: scroll.right, constant: -40).isActive = true
            top = text.bottomAnchor
        }
        
        scroll.bottom.constraint(equalTo: top, constant: 40).isActive = true
    }
}
