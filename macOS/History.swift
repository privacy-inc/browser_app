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
    private var size = CGSize.zero
    private var subs = Set<AnyCancellable>()
    private var cells = Set<Cell>()
    private var pages = [Page]()
    private var positions = [UUID : CGPoint]()
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
            self?.refresh()
        }.store(in: &subs)
        
        (NSApp as! App).pages.sink { [weak self] in
            content.subviews.forEach { $0.removeFromSuperview() }
            self?.pages = $0
            self?.refresh()
        }.store(in: &subs)
    }
    
    override func mouseDown(with: NSEvent) {
        super.mouseDown(with: with)
        window?.makeFirstResponder(self)
    }
    
    override func mouseUp(with: NSEvent) {
        guard let page = cell(with)?.page else { return }
        browser.browse.send(page.url)
    }
    
    private func refresh() {
        reposition()
        render()
    }
    
    private func reposition() {
        var positions = [UUID : CGPoint]()
        var current = CGPoint(x: horizontal - size.width, y: vertical)
        pages.forEach {
            current.x += size.width + padding
            if current.x + size.width > bounds.width - horizontal {
                current = .init(x: horizontal + padding, y: current.y + size.height + padding)
            }
            positions[$0.id] = current
        }
        self.positions = positions
        documentView!.frame.size.height = max(current.y + size.height + vertical, frame.size.height)
    }
    
    private func render() {
        let current = self.current
        cells
            .filter { $0.page != nil }
            .filter { !current.contains($0.page!.id) }
            .forEach {
                $0.removeFromSuperview()
                $0.page = nil
            }
        current.forEach { id in
            let cell = cells.first { $0.page?.id == id } ?? cells.first { $0.page == nil } ?? {
                cells.insert($0)
                return $0
            } (Cell(formatter: formatter))
            cell.page = pages.first { $0.id == id }
            cell.frame = .init(origin: positions[id]!, size: size)
            cell.dequeue()
            documentView!.addSubview(cell)
        }
    }
    
    private var current: Set<UUID> {
        let min = contentView.bounds.minY - size.height
        let max = contentView.bounds.maxY + 1
        return .init(positions.filter {
            $0.1.y > min && $0.1.y < max
        }.map(\.0))
    }
    
    private func cell(_ with: NSEvent) -> Cell? {
        positions
            .map { ($0.0, CGRect(origin: $0.1, size: size)) }
            .first { $0.1.contains(documentView!.convert(with.locationInWindow, from: nil)) }
            .flatMap { item in
                cells.first { $0.page?.id == item.0 }
            }
    }
}
