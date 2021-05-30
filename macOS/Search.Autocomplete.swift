import AppKit
import Combine
import Sleuth

extension Search {
    final class Autocomplete: NSPanel, NSWindowDelegate {
        let filter = PassthroughSubject<String, Never>()
        private weak var content: NSVisualEffectView!
        private var monitor: Any?
        private var subs = Set<AnyCancellable>()
        
        init(id: UUID) {
            super.init(contentRect: .zero, styleMask: [.borderless], backing: .buffered, defer: true)
            isMovable = false
            isOpaque = false
            backgroundColor = .clear
            hasShadow = true
            delegate = self
            
            let content = NSVisualEffectView()
            content.translatesAutoresizingMaskIntoConstraints = false
            content.wantsLayer = true
            content.layer!.cornerRadius = 4
            contentView!.addSubview(content)
            self.content = content
            
            content.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
            content.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
            content.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        }
        
        func start() {
            guard
                monitor == nil,
                subs.isEmpty
            else { return }
            
            let cells = PassthroughSubject<[Cell], Never>()
            
            monitor = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { [weak self] event in
                guard
                    let self = self,
                    self.isVisible,
                    event.window != self
                else { return event }
                self.end()
                return event
            }
            
            cloud
                .archive
                .combineLatest(filter)
                .sink { [weak self] (archive: Archive, filter: String) in
                    guard let self = self else { return }
                    self
                        .content
                        .subviews
                        .forEach {
                            $0.removeFromSuperview()
                        }
                    
                    guard !filter.isEmpty else {
                        self.end()
                        return
                    }
                    var list = [Cell]()
                    var top = self.content.topAnchor
                    let bookmarks = archive
                        .bookmarks
                        .filter(filter)
                    
                    if !bookmarks.isEmpty {
                        let title = Text()
                        title.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .bold)
                        title.textColor = .secondaryLabelColor
                        title.stringValue = NSLocalizedString("Bookmarks", comment: "")
                    }
                    
                    if list.isEmpty {
                        self.end()
                    } else {
                        
                        cells.send(list)
                    }
                }
                .store(in: &subs)
        }
        
        func end() {
            monitor
                .map(NSEvent.removeMonitor)
            monitor = nil
            subs = []
            parent?.removeChildWindow(self)
            orderOut(nil)
        }
    }
}
