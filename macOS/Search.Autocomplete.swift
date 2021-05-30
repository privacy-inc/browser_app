import AppKit
import Combine
import Sleuth

extension Search {
    final class Autocomplete: NSPanel, NSWindowDelegate {
        let filter = PassthroughSubject<String, Never>()
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
            
            content.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
            content.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
            content.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
            content.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        }
        
        func start() {
            guard
                monitor == nil,
                subs.isEmpty
            else { return }
            
            let views = PassthroughSubject<[NSView], Never>()
            
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
                    guard !filter.isEmpty else {
                        self?.end()
                        return
                    }
                    var list = [NSView]()
                    
                    if list.isEmpty {
                        self?.end()
                    } else {
                        
                        views.send(list)
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
