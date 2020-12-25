import AppKit
import Combine
import Sleuth

final class History: NSScrollView {
    override var frame: NSRect {
        didSet {
            documentView!.frame.size.width = frame.width
            map.bounds = contentView.bounds
        }
    }
    
    private weak var browser: Browser!
    private var cells = Set<Cell>()
    private var subs = Set<AnyCancellable>()
    private let map = Map()
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
            guard let bounds = self?.contentView.bounds else { return }
            self?.map.bounds = bounds
        }.store(in: &subs)
        
        (NSApp as! App).pages.sink { [weak self] in
            content.subviews.forEach { $0.removeFromSuperview() }
            self?.map.pages = $0
            self?.reposition()
        }.store(in: &subs)
        
        map.items.sink { [weak self] items in
            guard let self = self else { return }
            self.cells
                .filter { $0.page != nil }
                .filter { cell in !items.contains { $0.page == cell.page } }
                .forEach {
                    $0.removeFromSuperview()
                    $0.page = nil
                }
            items.forEach { item in
                let cell = self.cells.first { $0.page == item.page } ?? self.cells.first { $0.page == nil } ?? {
                    self.cells.insert($0)
                    return $0
                } (Cell(formatter: self.formatter))
                cell.page = item.page
                cell.frame = item.frame
                cell.dequeue()
                self.documentView!.addSubview(cell)
            }
        }.store(in: &subs)
        
        map.height.sink { [weak self] in
            guard let frame = self?.frame else { return }
            content.frame.size.height = max($0, frame.size.height)
        }.store(in: &subs)
    }
    
    override func mouseDown(with: NSEvent) {
        super.mouseDown(with: with)
        window?.makeFirstResponder(self)
    }
    
    override func mouseUp(with: NSEvent) {
        guard var page = cell(with)?.page else { return }
        page.date = .init()
        browser.page.value = page
        browser.browse.send(page.url)
    }
    
    private func reposition() {
        var positions = [UUID : CGPoint]()
        var current = CGPoint(x: Frame.horizontal - size.width, y: Frame.vertical)
        pages.forEach {
            current.x += size.width + Frame.padding
            if current.x + size.width > bounds.width - Frame.horizontal {
                current = .init(x: Frame.horizontal + Frame.padding, y: current.y + size.height + Frame.padding)
            }
            positions[$0.id] = current
        }
        self.positions = positions
        documentView!.frame.size.height = max(current.y + size.height + Frame.vertical, frame.size.height)
        visible = []
        render()
    }
    
    private func render() {
        let visible = viewrect
        guard self.visible != visible else { return }
        self.visible = visible
        cells
            .filter { $0.page != nil }
            .filter { !visible.contains($0.page!.id) }
            .forEach {
                $0.removeFromSuperview()
                $0.page = nil
            }
        visible.forEach { id in
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
    
    private var viewrect: Set<UUID> {
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
