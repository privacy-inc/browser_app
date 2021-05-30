import AppKit

extension Search {
    final class Autocomplete: NSPanel, NSWindowDelegate {
        private var monitor: Any?
        
        init(id: UUID) {
            super.init(contentRect: .zero, styleMask: [.borderless], backing: .buffered, defer: true)
            isMovable = false
            isOpaque = false
            backgroundColor = .clear
            hasShadow = true
            delegate = self
            
            let content = NSView()
            content.translatesAutoresizingMaskIntoConstraints = false
            content.wantsLayer = true
            content.layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
            content.layer!.cornerRadius = 4
            contentView!.addSubview(content)
            
            content.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
            content.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
            content.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
            content.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        }
        
        func start() {
            guard monitor == nil else { return }
            monitor = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { [weak self] event in
                guard
                    let self = self,
                    self.isVisible,
                    event.window != self
                else { return event }
                self.end()
                return event
            }
        }
        
        func end() {
            parent?.removeChildWindow(self)
            monitor
                .map(NSEvent.removeMonitor)
            monitor = nil
            orderOut(nil)
        }
    }
}
