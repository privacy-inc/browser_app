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
            self.map {
                $0.map.bounds = $0.contentView.bounds
            }
        }.store(in: &subs)
        
        (NSApp as! App).pages.sink { [weak self] in
            content.subviews.forEach { $0.removeFromSuperview() }
            self?.map.pages = $0.map(Map.Page.init(page:))
        }.store(in: &subs)
        
        map.items.sink { [weak self] items in
            guard let self = self else { return }
            self.cells
                .filter { $0.page != nil }
                .filter { cell in !items.contains { $0.page.page == cell.page?.page } }
                .forEach {
                    $0.removeFromSuperview()
                    $0.page = nil
                }
            items.forEach { item in
                let cell = self.cells.first { $0.page?.page == item.page.page } ?? self.cells.first { $0.page == nil } ?? {
                    self.cells.insert($0)
                    return $0
                } (Cell())
                cell.page = item.page
                cell.frame = item.frame
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
        guard var page = map.page(for: documentView!.convert(with.locationInWindow, from: nil))?.page else { return }
        page.date = .init()
        browser.page.value = page
        browser.browse.send(page.url)
    }
}
