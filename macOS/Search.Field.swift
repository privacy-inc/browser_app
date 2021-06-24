import AppKit
import Combine

extension Search {
    final class Field: NSTextField, NSTextFieldDelegate {
        private let autocomplete: Autocomplete
        private var subs = Set<AnyCancellable>()
        private let id: UUID
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            Self.cellClass = Cell.self
            self.id = id
            autocomplete = .init(id: id)
            super.init(frame: .zero)
            bezelStyle = .roundedBezel
            translatesAutoresizingMaskIntoConstraints = false
            font = .preferredFont(forTextStyle: .body)
            controlSize = .large
            delegate = self
            lineBreakMode = .byTruncatingMiddle
            target = self
            action = #selector(search)
            textColor = .labelColor
            isAutomaticTextCompletionEnabled = false
            
            cloud
                .archive
                .combineLatest(tabber
                                .items
                                .map {
                                    $0[state: id]
                                        .browse
                                }
                                .compactMap {
                                    $0
                                }
                                .removeDuplicates())
                .map {
                    $0.0
                        .page($0.1)
                        .access
                        .string
                }
                .filter {
                    !$0.isEmpty
                }
                .removeDuplicates()
                .sink { [weak self] in
                    self?.stringValue = $0
                }
                .store(in: &subs)
            
            tabber
                .items
                .value[state: id]
                .browse
                .map(cloud.archive.value.page)
                .map(\.access.string)
                .map {
                    stringValue = $0
                }
            
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
        
        override func resignFirstResponder() -> Bool {
            autocomplete.end()
            return super.resignFirstResponder()
        }
        
        override func textDidChange(_: Notification) {
            if !autocomplete.isVisible {
                window!.addChildWindow(autocomplete, ordered: .above)
                autocomplete.start()
                
                ;{
                    autocomplete.adjust.send((position: .init(x: $0.x, y: $0.y - 3), width: bounds.width))
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
            case #selector(cancelOperation), #selector(complete), #selector(NSSavePanel.cancel):
                if autocomplete.isVisible {
                    autocomplete.end()
                } else {
                    window!.makeFirstResponder(superview!)
                    tabber
                        .items
                        .value[state: id]
                        .browse
                        .map(cloud.archive.value.page)
                        .map(\.access.string)
                        .map {
                            stringValue = $0
                        }
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
        
        @objc private func search() {
            autocomplete.end()
            window!.makeFirstResponder(window!.contentView)
            
            let state = tabber.items.value[state: id]
            cloud
                .browse(stringValue, browse: state.browse) { [weak self] in
                    guard let id = self?.id else { return }
                    if state.browse == $0 {
                        if state.isError {
                            tabber.browse(id, $0)
                        }
                        session.load.send((id: id, access: $1))
                    } else {
                        tabber.browse(id, $0)
                    }
                }
        }
    }
}
