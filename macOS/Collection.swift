import AppKit
import Combine

final class Collection: NSScrollView {
    let items = PassthroughSubject<Set<Item>, Never>()
    let size = PassthroughSubject<CGSize, Never>()
    let selected = PassthroughSubject<Int, Never>()
    private var subs = Set<AnyCancellable>()
    private let select = PassthroughSubject<CGPoint, Never>()
    private let highlight = PassthroughSubject<CGPoint, Never>()
    private let clear = PassthroughSubject<Date, Never>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let content = Flip()
        content.wantsLayer = true
        documentView = content
        hasVerticalScroller = true
        hasHorizontalScroller = true
        verticalScroller!.controlSize = .mini
        horizontalScroller!.controlSize = .mini
        postsFrameChangedNotifications = true
        contentView.postsBoundsChangedNotifications = true
        contentView.postsFrameChangedNotifications = true
        drawsBackground = false
        addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .mouseMoved, .activeInActiveApp, .inVisibleRect], owner: self))
        
        var cells = Set<Cell>()
        let clip = PassthroughSubject<CGRect, Never>()
            
        clip
            .combineLatest(size) {
                .init(width: max($0.width, $1.width), height: max($0.height, $1.height))
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
                        !items.contains {
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
        
        NotificationCenter.default.publisher(for: NSView.boundsDidChangeNotification, object: contentView)
            .merge(with: NotificationCenter.default.publisher(for: NSView.frameDidChangeNotification, object: contentView))
            .compactMap {
                ($0.object as? NSClipView)?.documentVisibleRect
            }
            .debounce(for: .milliseconds(5), scheduler: DispatchQueue.main)
            .sink(receiveValue: clip.send)
            .store(in: &subs)
        
        
        
        
        
        
        
        
        highlight
            .combineLatest(selected, editing)
            .filter {
                $1 == nil && !$2
            }.sink { point, _, _ in
                cells.forEach {
                    $0.state = $0.frame.contains(point) ? .highlighted : .none
                }
            }.store(in: &subs)
        
        drag
            .combineLatest(selected, dragging)
            .removeDuplicates {
                $0.0.0 == $1.0.0
            }
            .filter {
                $1 != nil && $2 == nil
            }
            .sink { _, selected, _ in
                dragging.send(selected)
            }.store(in: &subs)
        
        drag
            .combineLatest(dragging)
            .filter {
                $1 != nil
            }.sink {
                $1!.frame = $1!.frame.offsetBy(dx: $0.1.width, dy: $0.1.height)
            }.store(in: &subs)
        
        select.sink { point in
            selected.send(
                cells.cards.first {
                    $0.item!.rect.contains(point)
                }
            )
        }.store(in: &subs)
        
        double.sink { point in
            selected.send(nil)
            dragging.send(nil)
            if let cell = cells.cards.first(where: {
                $0.item!.rect.contains(point)
            }) {
                Session.edit.send(.edit(cell.item!.path))
            } else {
                Session.edit.send(nil)
            }
        }.store(in: &subs)
        
        edit.sink { [weak self] point in
            cells.cards.first {
                $0.item!.rect.contains(point)
            }.map {
                self?.editing.send(true)
                
                let edit = Cell.Edit(path: $0.item!.path)
                edit.delegate = self
                edit.show(relativeTo: $0.bounds, of: $0, preferredEdge: .minY)
                $0.state = .highlighted
            }
        }.store(in: &subs)
        
        clear
            .combineLatest(editing)
            .filter {
                !$1
            }
            .removeDuplicates {
                $0.0 == $1.0
            }
            .sink { _, _ in
                cells.filter{
                    $0.state != .none
                }.forEach {
                    $0.state = .none
                }
            }.store(in: &subs)
        
        drop.delay(for: .milliseconds(100), scheduler: DispatchQueue.main).sink { _ in
            selected.send(nil)
            dragging.send(nil)
        }.store(in: &subs)
        
        selected.send(nil)
        dragging.send(nil)
        editing.send(false)
    }
    
    override func mouseExited(with: NSEvent) {
        clear.send(.init())
    }
    
    override func mouseMoved(with: NSEvent) {
        highlight.send(point(with: with))
    }
    
    override func mouseDown(with: NSEvent) {
        switch with.clickCount {
        case 1:
            select.send(point(with: with))
        case 2:
            double.send(point(with: with))
        default:
            break
        }
    }
    
    override func rightMouseDown(with: NSEvent) {
        edit.send(point(with: with))
    }
    
    override func mouseDragged(with: NSEvent) {
        drag.send((.init(), .init(width: with.deltaX, height: with.deltaY)))
    }
    
    override func mouseUp(with: NSEvent) {
        drop.send(.init())
    }
    
    func popoverDidShow(_: Notification) {
        editing.send(true)
    }
    
    func popoverWillClose(_: Notification) {
        editing.send(false)
    }
 
    private func point(with: NSEvent) -> CGPoint {
        documentView!.convert(with.locationInWindow, from: nil)
    }
}
