import AppKit
import Combine

extension New.Cell {
    final class Icon: CALayer {
        let domain = PassthroughSubject<String, Never>()
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) { super.init(layer: layer) }
        override init() {
            super.init()
            contentsGravity = .resizeAspect
            masksToBounds = true
            
            let base = NSImage(systemSymbolName: "app", accessibilityDescription: nil)?
                .withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 18, weight: .medium))
            
            domain
                .removeDuplicates()
                .sink {
                    favicon.load(domain: $0)
                }
                .store(in: &subs)
            
            domain
                .removeDuplicates()
                .combineLatest(favicon
                                .icons
                                .removeDuplicates())
                .map {
                    $0.1[$0.0]
                }
                .removeDuplicates()
                .map {
                    $0
                        .flatMap(NSImage.init(data:))
                        ?? base
                }
                .sink { [weak self] in
                    self?.contents = $0
                }
                .store(in: &subs)
        }
        
        override func hitTest(_: CGPoint) -> CALayer? {
            nil
        }
        
        override class func defaultAction(forKey: String) -> CAAction? {
            NSNull()
        }
    }
}
