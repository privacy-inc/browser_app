import AppKit
import Combine

extension Bar {
    final class Menu: NSPopover {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(session: Session, id: UUID) {
            super.init()
            behavior = .semitransient
            contentSize = .init(width: 50, height: 160)
            contentViewController = .init()
            contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
            
            let xmark = Item(image: "xmark")
            xmark
                .click
                .sink {
                    session
                        .close
                        .send(id)
                }
                .store(in: &subs)
            
            var top = contentViewController!.view
            [xmark]
                .forEach {
                    contentViewController!.view.addSubview($0)
                    $0.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
                    $0.topAnchor.constraint(equalTo: top == contentViewController!.view ? top.topAnchor : top.bottomAnchor, constant:
                                                top == contentViewController!.view
                                                ? 12
                                                : 3).isActive = true
                    top = $0
                }
        }
    }
}
