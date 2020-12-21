import AppKit
import Combine
import Sleuth

final class History: NSScrollView {
    override var frame: NSRect {
        didSet {
            documentView!.frame.size.width = frame.width
            let total = frame.width - (horizontal * 2) - padding
            let width = self.width + padding
            let count = floor(total / width)
            let delta = total.truncatingRemainder(dividingBy: width) / count
            size = .init(width: self.width + delta, height: height + max(0, 60 - delta))
            refresh()
        }
    }
    
    private weak var browser: Browser!
    private var positions = [CGPoint]()
    private var size = CGSize.zero
    private var subs = Set<AnyCancellable>()
    private var queue = Set<Cell>()
    private var active = Set<Cell>()
    private var pages = [Page]()
    private var visible = [Bool]()
    private let width = CGFloat(220)
    private let height = CGFloat(110)
    private let padding = CGFloat(20)
    private let horizontal = CGFloat(40)
    private let vertical = CGFloat(60)
    private let formatter = RelativeDateTimeFormatter()
    
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        super.init(frame: .zero)
        let content = Flip()
        translatesAutoresizingMaskIntoConstraints = false
        documentView = content
        hasVerticalScroller = true
        contentView.postsBoundsChangedNotifications = true
        drawsBackground = false
        self.browser = browser
        
        NotificationCenter.default.publisher(for: NSView.boundsDidChangeNotification, object: contentView).sink { [weak self] _ in
            guard self?.isHidden == false else { return }
            self?.refresh()
        }.store(in: &subs)
        
        (NSApp as! App).pages.sink { [weak self] in
            content.subviews.forEach { $0.removeFromSuperview() }
            self?.queue = []
            self?.active = []
            self?.pages = $0
            self?.visible = .init(repeating: false, count: $0.count)
            self?.refresh()
        }.store(in: &subs)
    }
    
    override func mouseUp(with: NSEvent) {
        guard
            let cell = cell(with),
            cell.index < pages.count
        else { return }
        browser.browse.send(pages[cell.index].url)
    }
    
    private func refresh() {
        reposition()
        render()
    }
    
    private func reposition() {
        var positions = [CGPoint]()
        var current = CGPoint(x: horizontal - size.width, y: vertical)
        pages.forEach { _ in
            current.x += size.width + padding
            if current.x + size.width > bounds.width - horizontal {
                current = .init(x: horizontal + padding, y: current.y + size.height + padding)
            }
            positions.append(current)
        }
        self.positions = positions
        documentView!.frame.size.height = max(current.y + size.height + vertical, frame.size.height)
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
            let cell = queue.popFirst() ?? Cell(formatter: formatter)
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
