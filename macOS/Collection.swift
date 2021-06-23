import AppKit
import Combine

class Collection<Cell>: NSScrollView, NSMenuDelegate where Cell : CollectionCell {
    final var subs = Set<AnyCancellable>()
    final let items = PassthroughSubject<Set<CollectionItem>, Never>()
    final let height = PassthroughSubject<CGFloat, Never>()
    final let selected = PassthroughSubject<Int, Never>()
    final let highlighted = CurrentValueSubject<Int?, Never>(nil)
    private let select = PassthroughSubject<CGPoint, Never>()
    private let press = PassthroughSubject<CGPoint, Never>()
    private let clear = PassthroughSubject<Void, Never>()
    private let highlight = PassthroughSubject<CGPoint, Never>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let content = Flip()
        content.wantsLayer = true
        documentView = content
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        contentView.postsBoundsChangedNotifications = true
        contentView.postsFrameChangedNotifications = true
        drawsBackground = false
        addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .mouseMoved, .activeInActiveApp, .inVisibleRect], owner: self))
        
        menu = NSMenu()
        menu!.delegate = self
        
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
            .sink { items in
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
                        cell.item = item
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
        
        highlight
            .sink { point in
                cells
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
            .subscribe(highlighted)
            .store(in: &subs)
        
        press
            .map { point in
                cells
                    .first {
                        $0.frame.contains(point)
                    }
            }
            .compactMap {
                $0
            }
            .sink {
                $0.state = .pressed
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
            .subscribe(selected)
            .store(in: &subs)
        
        clear
            .sink {
                cells
                    .filter{
                        $0.state != .none
                    }
                    .forEach {
                        $0.state = .none
                    }
            }
            .store(in: &subs)
    }
    
    @objc func delete() {
        
    }
    
    final func menuNeedsUpdate(_ menu: NSMenu) {
        menu.items = highlighted.value == nil
            ? []
            : [.child("Delete", #selector(delete)) {
                $0.target = self
                $0.image = .init(systemSymbolName: "trash", accessibilityDescription: nil)
            }]
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
        press.send(point(with: with))
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
    
    private func point(with: NSEvent) -> CGPoint {
        documentView!.convert(with.locationInWindow, from: nil)
    }
}
