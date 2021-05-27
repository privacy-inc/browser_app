import AppKit
import Combine

class Collection<Cell>: NSScrollView where Cell : CollectionCell {
    var subs = Set<AnyCancellable>()
    let items = PassthroughSubject<Set<CollectionItem>, Never>()
    let height = PassthroughSubject<CGFloat, Never>()
    let selected = PassthroughSubject<Int, Never>()
    private let select = PassthroughSubject<CGPoint, Never>()
    private let highlight = PassthroughSubject<CGPoint, Never>()
    private let clear = PassthroughSubject<Void, Never>()
    
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
        
        NotificationCenter
            .default
            .publisher(for: NSView.boundsDidChangeNotification, object: contentView)
            .merge(with: NotificationCenter
                    .default
                    .publisher(for: NSView.frameDidChangeNotification, object: contentView))
            .compactMap {
                ($0.object as? NSClipView)?.documentVisibleRect
            }
            .debounce(for: .milliseconds(5), scheduler: DispatchQueue.main)
            .subscribe(clip)
            .store(in: &subs)
        
        highlight
            .sink { point in
                cells.forEach {
                    $0.state = $0.frame.contains(point)
                        ? .highlighted
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
    
    final override func mouseExited(with: NSEvent) {
        clear.send()
    }
    
    final override func mouseMoved(with: NSEvent) {
        highlight.send(point(with: with))
    }
    
    final override func mouseDown(with: NSEvent) {
        select.send(point(with: with))
    }
 
    private func point(with: NSEvent) -> CGPoint {
        documentView!.convert(with.locationInWindow, from: nil)
    }
}
