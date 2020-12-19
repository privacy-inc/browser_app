import AppKit
import Combine
import Sleuth

final class History: NSScrollView {
    override var frame: NSRect {
        didSet {
            documentView!.frame.size.width = frame.width
            let total = frame.width - 1
            let width = self.width + 1
            let count = floor(total / width)
            let delta = total.truncatingRemainder(dividingBy: width) / count
            size = .init(width: self.width + delta, height: height)
            refresh()
        }
    }
    
    private(set) var positions = [CGPoint]()
    private(set) var size = CGSize.zero
    private var subs = Set<AnyCancellable>()
    private var queue = Set<Cell>()
    private var active = Set<Cell>()
    private var visible = [Bool]()
    private var pages = [Page]()
    private let width = CGFloat(320)
    private let height = CGFloat(60)
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let content = Flip()
        translatesAutoresizingMaskIntoConstraints = false
        documentView = content
        hasVerticalScroller = true
        contentView.postsBoundsChangedNotifications = true
        drawsBackground = false
        
        NotificationCenter.default.publisher(for: NSView.boundsDidChangeNotification, object: contentView).sink { [weak self] _ in
            guard self?.isHidden == false else { return }
            self?.refresh()
        }.store(in: &subs)
        
        var load: AnyCancellable?
        load = FileManager.pages.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.pages = $0
            self?.visible = .init(repeating: false, count: $0.count)
            self?.refresh()
            print($0.count)
            load?.cancel()
        }
    }
    
//    override func mouseDown(with: NSEvent) {
//        guard
//            !main.zoom.value,
//            let cell = cell(with)
//        else { return }
//        selected.value[cell.index].toggle()
//        cell.highlighted = selected.value[cell.index]
//        if with.clickCount == 2 {
//            main.zoom.value = true
//            main.index.value = cell.index
//        }
//    }
    
    private func refresh() {
        reposition()
        render()
    }
    
    private func reposition() {
        var positions = [CGPoint]()
        var current = CGPoint(x: -size.width, y: 2)
        pages.forEach { _ in
            current.x += size.width + 1
            if current.x + size.width > bounds.width {
                current = .init(x: 1, y: current.y + size.height + 1)
            }
            positions.append(current)
        }
        self.positions = positions
        documentView!.frame.size.height = max(current.y + size.height + 2, frame.size.height)
    }
    
    private func render() {
        let current = self.current
        let visible = self.visible
        (0 ..< pages.count).filter { visible[$0] }.forEach { index in
            guard !current.contains(index) else { return }
            let cell = active.remove(at: active.firstIndex { $0.index == index }!)
            cell.removeFromSuperview()
            cell.item = nil
            self.visible[index] = false
            queue.insert(cell)
        }
        current.forEach {
            let item = cell($0)
            item.frame = .init(origin: positions[$0], size: size)
        }
    }
    
    private var current: Set<Int> {
        let min = contentView.bounds.minY - size.height
        let max = contentView.bounds.maxY + 1
        return .init((0 ..< pages.count).filter {
            positions[$0].y > min && positions[$0].y < max
        })
    }
    
    private func cell(_ index: Int) -> Cell {
        guard visible[index] else {
            let cell = queue.popFirst() ?? Cell()
            cell.index = index
            cell.item = pages[index]
            documentView!.addSubview(cell)
            active.insert(cell)
            visible[index] = true
            return cell
        }
        return active.first { $0.index == index }!
    }
    
    private func cell(_ with: NSEvent) -> Cell? {
        positions.map { CGRect(origin: $0, size: size) }.firstIndex { $0.contains(documentView!.convert(with.locationInWindow, from: nil)) }.flatMap { index in
            active.first { $0.index == index }
        }
    }
}
