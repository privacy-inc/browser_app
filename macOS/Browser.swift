import AppKit

final class Browser: NSView, NSTextFinderBarContainer {
    private var top: NSLayoutConstraint!
    private weak var finder: NSTextFinder!
    
    required init?(coder: NSCoder) { nil }
    init(web: Web) {
        super.init(frame: .zero)
        addSubview(web)
        finder = web.finder
        finder.findBarContainer = self
        
        top = web.topAnchor.constraint(equalTo: topAnchor)
        top.isActive = true
        web.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        web.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        web.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override func performTextFinderAction(_ sender: Any?) {
        (sender as? NSMenuItem)
            .flatMap {
                NSTextFinder.Action(rawValue: $0.tag)
            }
            .map {
                finder.performAction($0)

                switch $0 {
                case .showFindInterface:
                    isFindBarVisible = true
                default: break
                }
            }
    }
    
    var findBarView: NSView? {
        didSet {
            oldValue?.removeFromSuperview()
            findBarView
                .map {
                    $0.frame.size.width = 320
                    $0.frame.origin = .init(x: bounds.width - 330, y: bounds.height - ($0.frame.height + safeAreaInsets.top + 10))
                    $0.autoresizingMask = [.minXMargin, .minYMargin]
                    $0.layer?.backgroundColor = NSColor.red.cgColor
                    addSubview($0)
                }
        }
    }
    
    var isFindBarVisible = false {
        didSet {
            top.constant = isFindBarVisible ? 50 + safeAreaInsets.top : 0
            findBarView?.isHidden = !isFindBarVisible
        }
    }
    
    func findBarViewDidChangeHeight() {
        
    }
}
