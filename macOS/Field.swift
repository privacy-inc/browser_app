import AppKit
import Combine
import Sleuth

final class Field: NSTextField, NSTextFieldDelegate {
    private var subs = Set<AnyCancellable>()
    private let autocomplete: Autocomplete
    private let id: UUID
    private let session: Session
    
    required init?(coder: NSCoder) { nil }
    init(session: Session, id: UUID) {
        Self.cellClass = Cell.self
        self.id = id
        self.session = session
        autocomplete = .init(session: session, id: id)
        super.init(frame: .zero)
        bezelStyle = .roundedBezel
        translatesAutoresizingMaskIntoConstraints = false
        font = .preferredFont(forTextStyle: .body)
        controlSize = .large
        delegate = self
        lineBreakMode = .byTruncatingMiddle
        textColor = .labelColor
        isAutomaticTextCompletionEnabled = false
        
        let responder = (cell!.fieldEditor(for: self) as! Cell.Editor).responder
        
        cloud
            .archive
            .combineLatest(session
                            .tab
                            .items
                            .map {
                                $0[state: id]
                                    .browse
                            }
                            .compactMap {
                                $0
                            })
            .map {
                $0.0
                    .page($0.1)
                    .access
            }
            .combineLatest(responder)
            .compactMap {
                $1
                    ? nil
                    : {
                        switch $0 {
                        case let .remote(remote):
                            return remote.domain + remote.suffix
                        default:
                            return $0.short
                        }
                    } ($0)
            }
            .sink { [weak self] in
                self?.stringValue = $0
            }
            .store(in: &subs)
        
        responder
            .filter {
                $0
            }
            .compactMap { _ in
                session
                    .tab
                    .items
                    .value[state: id]
                    .browse
                    .flatMap(cloud.archive.value.page)
                    .map(\.access.value)
            }
            .sink { [weak self] in
                self?.stringValue = $0
            }
            .store(in: &subs)
            
        
        session
            .search
            .filter {
                $0 == id
            }
            .map { _ in
                
            }
            .sink { [weak self] in
                self?.window?.makeFirstResponder(self)
            }
            .store(in: &subs)
        
        autocomplete
            .complete
            .sink { [weak self] in
                self?.stringValue = $0
            }
            .store(in: &subs)
    }
    
    override var canBecomeKeyView: Bool {
        true
    }
    
    override func textDidChange(_: Notification) {
        if !autocomplete.isVisible {
            window!.addChildWindow(autocomplete, ordered: .above)
            autocomplete.start()
            
            ;{
                autocomplete.adjust.send((position: .init(x: $0.x - 14, y: $0.y - 1.5), width: bounds.width + 28))
            } (window!.convertPoint(toScreen: superview!.convert(frame.origin, to: nil)))
        }
        autocomplete
            .filter
            .send(stringValue.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    override func mouseDown(with: NSEvent) {
        selectText(nil)
    }
    
    func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
        switch doCommandBy {
        case #selector(insertNewline):
            autocomplete.end()
            
            let state = session.tab.items.value[state: id]
            cloud
                .browse(stringValue, browse: state.browse) { [weak self] in
                    guard let id = self?.id else { return }
                    if state.browse == $0 {
                        if state.isError {
                            self?.session.tab.browse(id, $0)
                        }
                        self?.session.load.send((id: id, access: $1))
                    } else {
                        self?.session.tab.browse(id, $0)
                    }
                }
            window!.makeFirstResponder(window!.contentView)
            
        case #selector(cancelOperation), #selector(complete), #selector(NSSavePanel.cancel):
            if autocomplete.isVisible {
                autocomplete.end()
            } else {
                window!.makeFirstResponder(superview!)
            }
        case #selector(moveUp):
            autocomplete.up.send(.init())
        case #selector(moveDown):
            autocomplete.down.send(.init())
        default:
            return false
        }
        return true
    }
    
    override func viewDidMoveToWindow() {
        window?.initialFirstResponder = self
    }
}
