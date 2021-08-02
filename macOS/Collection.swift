import AppKit
import Combine

class Collection<Cell, Info>: NSScrollView where Cell : CollectionCell<Info> {
    final var subs = Set<AnyCancellable>()
    final let items = PassthroughSubject<Set<CollectionItem<Info>>, Never>()
    final let height = PassthroughSubject<CGFloat, Never>()
    final let selected = CurrentValueSubject<Info.ID?, Never>(nil)
    final let highlighted = CurrentValueSubject<Info.ID?, Never>(nil)
    final let first = PassthroughSubject<Info.ID?, Never>()
    private let select = PassthroughSubject<CGPoint, Never>()
    private let clear = PassthroughSubject<Void, Never>()
    private let highlight = PassthroughSubject<CGPoint, Never>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let content = Flip()
        content.layer = Layer()
        content.wantsLayer = true
        documentView = content
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        contentView.postsBoundsChangedNotifications = true
        contentView.postsFrameChangedNotifications = true
        drawsBackground = false
        addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .inVisibleRect], owner: self))
        
        var cells = Set<Cell>()
        let clip = PassthroughSubject<CGRect, Never>()
            
        clip
            .combineLatest(height) {
                .init(width: $0.width, height: max($0.height, $1))
            }
            .removeDuplicates()
            .sink {
                content.frame.size = $0
            }
            .store(in: &subs)

        items
            .combineLatest(clip) { items, clip in
                items
                    .filter {
                        clip.intersects($0.rect)
                    }
            }
            .removeDuplicates()
            .combineLatest(first
                            .removeDuplicates(),
                           selected
                                .removeDuplicates())
            .sink { (items: Set<CollectionItem>, first: Info.ID?, selected: Info.ID?) in
                cells
                    .filter {
                        $0.item != nil
                    }
                    .filter { cell in
                        !items
                            .contains {
                                $0 == cell.item
                            }
                    }
                    .forEach {
                        $0.removeFromSuperlayer()
                        $0.item = nil
                    }
                
                items
                    .forEach { item in
                        let cell = cells
                            .first {
                                $0.item == item
                            }
                            ?? cells.first {
                                $0.item == nil
                            }
                            ?? {
                                cells.insert($0)
                                return $0
                            } (Cell())
                        cell.state = item.info.id == selected ? .pressed : .none
                        cell.item = item
                        cell.first = item.info.id == first
                        content.layer!.addSublayer(cell)
                    }
            }
            .store(in: &subs)
        
        NotificationCenter
            .default
            .publisher(for: NSView.boundsDidChangeNotification, object: contentView)
            .merge(with: NotificationCenter
                    .default
                    .publisher(for: NSView.frameDidChangeNotification, object: contentView))
            .compactMap {
                ($0.object as? NSClipView)?.documentVisibleRect
            }
            .subscribe(clip)
            .store(in: &subs)
        
        items
            .removeDuplicates()
            .map { _ in
                nil
            }
            .sink { [weak self] in
                self?.selected.send($0)
            }
            .store(in: &subs)
        
        highlight
            .sink { point in
                cells
                    .filter {
                        $0.state != .pressed
                    }
                    .forEach {
                        $0.state = $0.frame.contains(point)
                            ? .highlighted
                            : .none
                    }
            }
            .store(in: &subs)
        
        highlight
            .map { point in
                cells
                    .compactMap(\.item)
                    .first {
                        $0
                            .rect
                            .contains(point)
                    }
            }
            .map {
                $0?.info.id
            }
            .sink { [weak self] in
                self?.highlighted.send($0)
            }
            .store(in: &subs)
        
        selected
            .removeDuplicates()
            .sink { id in
                cells
                    .forEach {
                        $0.state = $0.item?.info.id == id
                            ? .pressed
                            : .none
                    }
            }
            .store(in: &subs)
        
        select
            .map { point in
                cells
                    .compactMap(\.item)
                    .first {
                        $0.rect.contains(point)
                    }
            }
            .compactMap {
                $0?.info.id
            }
            .sink { [weak self] in
                self?.selected.send($0)
            }
            .store(in: &subs)
        
        clear
            .sink {
                cells
                    .filter{
                        $0.state == .highlighted
                    }
                    .forEach {
                        $0.state = .none
                    }
            }
            .store(in: &subs)
    }
    
    final override func mouseExited(with: NSEvent) {
        clear.send()
    }
    
    final override func mouseMoved(with: NSEvent) {
        highlight.send(point(with: with))
    }
    
    final override func mouseDown(with: NSEvent) {
        guard with.clickCount == 1 else { return }
        window?.makeFirstResponder(self)
    }
    
    final override func mouseUp(with: NSEvent) {
        guard with.clickCount == 1 else { return }
        select.send(point(with: with))
    }
    
    final override func rightMouseDown(with: NSEvent) {
        highlight.send(point(with: with))
        super.rightMouseDown(with: with)
    }
    
    final override func acceptsFirstMouse(for: NSEvent?) -> Bool {
        true
    }
    
    final override func shouldDelayWindowOrdering(for: NSEvent) -> Bool {
        true
    }
    
    final override var allowsVibrancy: Bool {
        true
    }
    
    private func point(with: NSEvent) -> CGPoint {
        documentView!.convert(with.locationInWindow, from: nil)
    }
}
