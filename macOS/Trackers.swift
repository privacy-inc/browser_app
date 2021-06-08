import AppKit
import Combine

final class Trackers: NSWindow {
    private var subscription: AnyCancellable?
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 300, height: 380),
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        setFrameAutosaveName("Trackers")
        title = NSLocalizedString("Trackers", comment: "")
        center()
        contentView = NSVisualEffectView()
        
        let bar = NSTitlebarAccessoryViewController()
        bar.view = Title()
        bar.layoutAttribute = .top
        addTitlebarAccessoryViewController(bar)
        
        let domains = Text()
        contentView!.addSubview(domains)
        
        let incidences = Text()
        contentView!.addSubview(incidences)
        
        let separator = NSView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.wantsLayer = true
        separator.layer!.backgroundColor = NSColor.separatorColor.cgColor
        contentView!.addSubview(separator)
        
        let scroll = Scroll()
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        contentView!.addSubview(scroll)
        
        domains.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        domains.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 20).isActive = true
        
        incidences.topAnchor.constraint(equalTo: domains.topAnchor).isActive = true
        incidences.leftAnchor.constraint(equalTo: domains.rightAnchor, constant: 30).isActive = true
        
        separator.topAnchor.constraint(equalTo: domains.bottomAnchor, constant: 20).isActive = true
        separator.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scroll.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        scroll.right.constraint(equalTo: scroll.rightAnchor).isActive = true
        
        subscription = cloud
            .archive
            .map(\.trackers)
            .removeDuplicates {
                $0.flatMap(\.count) == $1.flatMap(\.count)
            }
            .sink { trackers in
                scroll
                    .views
                    .forEach {
                        $0.removeFromSuperview()
                    }
                
                domains.attributedStringValue = .make {
                    $0.append(.make(session.decimal.string(from: NSNumber(value: trackers.count)) ?? "",
                                    font: .monoDigit(style: .title1, weight: .regular)))
                    $0.linebreak()
                    $0.append(.make("Trackers", font: .preferredFont(forTextStyle: .callout), color: .secondaryLabelColor))
                }
                
                incidences.attributedStringValue = .make {
                    $0.append(.make(session.decimal.string(from: NSNumber(value: trackers
                                                                            .map(\.1.count)
                                                                            .reduce(0, +))) ?? "",
                                    font: .monoDigit(style: .title1, weight: .regular)))
                    $0.linebreak()
                    $0.append(.make("Attempts blocked", font: .preferredFont(forTextStyle: .callout), color: .secondaryLabelColor))
                }
                
                guard !trackers.isEmpty else { return }
                
                var top = scroll.top
                trackers
                    .map {
                        Item.init(name: $0.name, count: $0.count)
                    }
                    .forEach {
                        scroll.add($0)
                        
                        $0.leftAnchor.constraint(equalTo: scroll.left, constant: 20).isActive = true
                        $0.rightAnchor.constraint(equalTo: scroll.right, constant: -20).isActive = true
                        
                        if top != scroll.top {
                            let separator = NSView()
                            separator.translatesAutoresizingMaskIntoConstraints = false
                            separator.wantsLayer = true
                            separator.layer!.backgroundColor = NSColor.separatorColor.cgColor
                            
                            scroll.add(separator)
                            
                            separator.topAnchor.constraint(equalTo: top).isActive = true
                            separator.leftAnchor.constraint(equalTo: scroll.left, constant: 20).isActive = true
                            separator.rightAnchor.constraint(equalTo: scroll.right, constant: -20).isActive = true
                            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                            $0.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
                        } else {
                            $0.topAnchor.constraint(equalTo: top, constant: 10).isActive = true
                        }
                        
                        top = $0.bottomAnchor
                    }
                
                scroll.bottom.constraint(equalTo: top, constant: 10).isActive = true
            }
    }
}
