import AppKit
import Combine

final class Icon: NSImageView {
    let domain = PassthroughSubject<String, Never>()
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let base = NSImage(systemSymbolName: "app", accessibilityDescription: nil)?
            .withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        image = base
        translatesAutoresizingMaskIntoConstraints = false
        imageScaling = .scaleProportionallyDown
        
        widthAnchor.constraint(equalToConstant: 18).isActive = true
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        domain
            .removeDuplicates()
            .map { _ in
                
            }
            .sink { [weak self] in
                self?.image = base
            }
            .store(in: &subs)
        
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
            .compactMap {
                $0.1[$0.0]
            }
            .removeDuplicates()
            .compactMap {
                NSImage(data: $0)
            }
            .sink { [weak self] in
                self?.image = $0
            }
            .store(in: &subs)
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
}
