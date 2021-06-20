import AppKit
import Combine
import Sleuth

extension Search {
    final class Autocomplete: NSPanel {
        let filter = PassthroughSubject<String, Never>()
        let adjust = PassthroughSubject<(position: CGPoint, width: CGFloat), Never>()
        let up = PassthroughSubject<Date, Never>()
        let down = PassthroughSubject<Date, Never>()
        let complete = PassthroughSubject<String, Never>()
        private weak var content: NSVisualEffectView!
        private var monitor: Any?
        private var subs = Set<AnyCancellable>()
        private let hover = PassthroughSubject<(y: CGFloat, date: Date), Never>()
        private let select = PassthroughSubject<(y: CGFloat, date: Date), Never>()
        private let clear = PassthroughSubject<Date, Never>()
        private let id: UUID
        
        init(id: UUID) {
            self.id = id
            super.init(contentRect: .zero, styleMask: [.borderless], backing: .buffered, defer: true)
            isMovable = false
            isOpaque = false
            backgroundColor = .clear
            hasShadow = true
            
            let content = NSVisualEffectView()
            content.translatesAutoresizingMaskIntoConstraints = false
            content.state = .active
            content.wantsLayer = true
            content.layer!.cornerRadius = 4
            content.addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .mouseMoved, .activeInActiveApp, .inVisibleRect], owner: self))
            content.postsFrameChangedNotifications = true
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
            
            let titleBookmarks = Text()
            titleBookmarks.font = .preferredFont(forTextStyle: .callout)
            titleBookmarks.textColor = .tertiaryLabelColor
            titleBookmarks.stringValue = NSLocalizedString("BOOKMARKS", comment: "")
            
            let separator = Separator()
            
            let titleHistory = Text()
            titleHistory.font = titleBookmarks.font!
            titleHistory.textColor = .tertiaryLabelColor
            titleHistory.stringValue = NSLocalizedString("HISTORY", comment: "")
            
            adjust
                .combineLatest(NotificationCenter
                                .default
                                .publisher(for: NSView.frameDidChangeNotification, object: content)
                                .compactMap {
                                    ($0.object as? NSView)?.frame.height
                                }
                                .receive(on: DispatchQueue.main))
                .sink { [weak self] in
                    self?.setContentSize(.init(width: $0.0.width, height: $0.1))
                    self?.setFrameTopLeftPoint($0.0.position)
                }
                .store(in: &subs)
            
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
                    let history = archive
                        .browse
                        .filter(filter)
                    
                    if !bookmarks.isEmpty {
                        self.content.addSubview(titleBookmarks)
                        
                        titleBookmarks.topAnchor.constraint(equalTo: top, constant: 10).isActive = true
                        titleBookmarks.leftAnchor.constraint(equalTo: self.content.leftAnchor, constant: 15).isActive = true
                        top = titleBookmarks.bottomAnchor
                        
                        bookmarks
                            .map(Cell.init(filtered:))
                            .forEach {
                                self.content.addSubview($0)
                                $0.topAnchor.constraint(equalTo: top, constant: 2).isActive = true
                                $0.leftAnchor.constraint(equalTo: self.content.leftAnchor, constant: 10).isActive = true
                                $0.rightAnchor.constraint(equalTo: self.content.rightAnchor, constant: -10).isActive = true
                                top = $0.bottomAnchor
                                
                                list.append($0)
                            }
                    }
                    
                    if !history.isEmpty {
                        if !bookmarks.isEmpty {
                            self.content.addSubview(separator)
                            
                            separator.topAnchor.constraint(equalTo: top, constant: 10).isActive = true
                            separator.leftAnchor.constraint(equalTo: self.content.leftAnchor, constant: 15).isActive = true
                            separator.rightAnchor.constraint(equalTo: self.content.rightAnchor, constant: -15).isActive = true
                            top = separator.bottomAnchor
                        }
                        
                        self.content.addSubview(titleHistory)

                        titleHistory.topAnchor.constraint(equalTo: top, constant: 10).isActive = true
                        titleHistory.leftAnchor.constraint(equalTo: self.content.leftAnchor, constant: 15).isActive = true
                        top = titleHistory.bottomAnchor
                        
                        history
                            .map(Cell.init(filtered:))
                            .forEach {
                                self.content.addSubview($0)
                                $0.topAnchor.constraint(equalTo: top, constant: 2).isActive = true
                                $0.leftAnchor.constraint(equalTo: self.content.leftAnchor, constant: 10).isActive = true
                                $0.rightAnchor.constraint(equalTo: self.content.rightAnchor, constant: -10).isActive = true
                                top = $0.bottomAnchor

                                list.append($0)
                            }
                    }
                    
                    if list.isEmpty {
                        self.end()
                    } else {
                        self.content.bottomAnchor.constraint(equalTo: top, constant: 10).isActive = true
                        cells.send(list)
                    }
                }
                .store(in: &subs)
            
            hover
                .combineLatest(cells)
                .removeDuplicates {
                    $0.0.date >= $1.0.date
                }
                .compactMap { item in
                    item
                        .1
                        .first {
                            $0.frame.minY <= item.0.y
                                && $0.frame.maxY >= item.0.y
                        }
                }
                .sink {
                    $0.highlighted = true
                }
                .store(in: &subs)
            
            hover
                .combineLatest(cells)
                .removeDuplicates {
                    $0.0.date >= $1.0.date
                }
                .compactMap { item in
                    item
                        .1
                        .first {
                            $0.frame.minY <= item.0.y
                                && $0.frame.maxY >= item.0.y
                        }
                }
                .sink {
                    $0.highlighted = true
                }
                .store(in: &subs)
            
            clear
                .combineLatest(cells)
                .removeDuplicates {
                    $0.0 >= $1.0
                }
                .map {
                    $0.1
                }
                .sink {
                    $0
                        .forEach {
                            guard $0.highlighted else { return }
                            $0.highlighted = false
                        }
                }
                .store(in: &subs)
            
            select
                .combineLatest(cells)
                .removeDuplicates {
                    $0.0.date >= $1.0.date
                }
                .compactMap { item in
                    item
                        .1
                        .first {
                            $0.frame.minY <= item.0.y
                                && $0.frame.maxY >= item.0.y
                        }
                }
                .sink { [weak self] in
                    guard let id = self?.id else { return }
                    self?.parent?.makeFirstResponder(self?.parent?.contentView)
                    let browse = tabber.items.value[state: id].browse
                    cloud
                        .browse($0.filtered.url, id: browse) {
                            tabber.browse(id, $0)
                            if browse == $0 {
                                session.load.send((id: id, access: $1))
                            }
                        }
                    self?.end()
                }
                .store(in: &subs)
            
            up
                .combineLatest(cells)
                .removeDuplicates {
                    $0.0 >= $1.0
                }
                .map {
                    $0.1
                }
                .sink { [weak self] in
                    $0
                        .up
                        .map {
                            self?.complete.send($0)
                        }
                }
                .store(in: &subs)
            
            down
                .combineLatest(cells)
                .removeDuplicates {
                    $0.0 >= $1.0
                }
                .map {
                    $0.1
                }
                .sink { [weak self] in
                    $0
                        .down
                        .map {
                            self?.complete.send($0)
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
        
        override func mouseMoved(with: NSEvent) {
            clear.send(.init())
            hover.send((y: y(with: with), date: .init()))
        }
        
        override func mouseExited(with: NSEvent) {
            clear.send(.init())
        }
        
        override func mouseDown(with: NSEvent) {
            select.send((y: y(with: with), date: .init()))
        }
     
        private func y(with: NSEvent) -> CGFloat {
            content.convert(with.locationInWindow, from: nil).y
        }
    }
}
