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
        verticalScroller!.controlSize = .mini
        contentView.postsBoundsChangedNotifications = true
        drawsBackground = false
        self.browser = browser
        
        NotificationCenter.default.publisher(for: NSView.boundsDidChangeNotification, object: contentView).sink { [weak self] _ in
            self.map {
                $0.map.bounds = $0.contentView.bounds
            }
        }.store(in: &subs)
        
        Synch
            .cloud
            .archive
            .combineLatest(browser.search)
            .sink { [weak self] in
                self?.map.pages = ({ entries, search in
                    search.isEmpty
                        ? entries
                        : entries
                            .filter {
                                $0.title.localizedCaseInsensitiveContains(search)
                                    || $0.url.localizedCaseInsensitiveContains(search)
                            }
                } ($0.0.entries.reversed(), $0.1.trimmingCharacters(in: .whitespacesAndNewlines))).map(Map.Page.init(entry:))
            }
            .store(in: &subs)
        
        map.items.sink { [weak self] items in
            guard let self = self else { return }
            self.cells
                .filter { $0.page != nil }
                .filter { cell in !items.contains { $0.page.entry == cell.page?.entry } }
                .forEach {
                    $0.removeFromSuperview()
                    $0.page = nil
                }
            items.forEach { item in
                let cell = self.cells.first { $0.page?.entry == item.page.entry } ?? self.cells.first { $0.page == nil } ?? {
                    self.cells.insert($0)
                    return $0
                } (Cell())
                cell.page = item.page
                cell.frame = item.frame
                content.addSubview(cell)
            }
        }.store(in: &subs)
        
        map.height.sink { [weak self] in
            guard let frame = self?.frame else { return }
            content.frame.size.height = max($0, frame.size.height)
        }.store(in: &subs)
        
        browser.search.send("")
    }
    
    override func mouseDown(with: NSEvent) {
        super.mouseDown(with: with)
        window?.makeFirstResponder(self)
    }
    
    override func mouseUp(with: NSEvent) {
        guard let entry = map.page(for: documentView!.convert(with.locationInWindow, from: nil))?.entry else { return }
        Synch.cloud.revisit(entry)
        browser.entry.value = entry
    }
}
