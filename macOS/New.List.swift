import AppKit
import Combine
import Sleuth

extension New {
    class List: Collection<Cell, Info>, NSMenuDelegate {
        final let info = PassthroughSubject<[Info], Never>()
        
        required init?(coder: NSCoder) { nil }
        init(session: Session, id: UUID) {
            super.init()
            menu = NSMenu()
            menu!.delegate = self
            
            let width = PassthroughSubject<CGFloat, Never>()
            
            NotificationCenter
                .default
                .publisher(for: NSView.frameDidChangeNotification, object: contentView)
                .compactMap {
                    ($0.object as? NSView)?.bounds.width
                }
                .map {
                    $0 - New.insets2
                }
                .removeDuplicates()
                .subscribe(width)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .combineLatest(width
                                .removeDuplicates())
                .sink { [weak self] (info: [Info], width: CGFloat) in
                    let result = info
                        .reduce(into: (items: Set<CollectionItem<Info>>(), y: New.insets_2)) {
                            let height = ceil($1.string.height(for: width - (Cell.insets2 + Cell.icon)) + Cell.insets2)
                            $0.items.insert(.init(
                                                info: $1,
                                                rect: .init(
                                                    x: New.insets,
                                                    y: $0.y,
                                                    width: width,
                                                    height: height)))
                            $0.y += height + 2
                        }
                    self?.items.send(result.items)
                    self?.height.send(result.y + New.insets_2)
                }
                .store(in: &subs)
        }
        
        @objc func delete() {
            
        }
        
        final func menuNeedsUpdate(_ menu: NSMenu) {
            menu.items = highlighted.value == nil
                ? []
                : [.child("Delete", #selector(delete)) {
                    $0.target = self
                    $0.image = .init(systemSymbolName: "trash", accessibilityDescription: nil)
                }]
        }
    }
}
