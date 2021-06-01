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
        
        func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
            switch doCommandBy {
            case #selector(cancelOperation), #selector(complete):
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
            
            let browse = tabber.items.value[state: id].browse
            cloud
                .browse(stringValue, id: browse) { [weak self] in
                    guard let id = self?.id else { return }
                    if browse == $0 {
    //                    if case .error = self?.wrapper.session.tab.state(id) {
    //                        self?.wrapper.session.tab.browse(id, $0)
    //                    }
                        session.load.send((id: id, access: $1))
                    } else {
                        tabber.browse(id, $0)
                    }
                }
        }
    }
}
