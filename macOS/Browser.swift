import AppKit

final class Browser: NSView, NSTextFinderBarContainer {
    private weak var top: NSLayoutConstraint!
    
    deinit {
        print("browser gone")
    }
    
    required init?(coder: NSCoder) { nil }
    init(web: Web) {
        super.init(frame: .zero)
        let first = NSVisualEffectView()
        first.translatesAutoresizingMaskIntoConstraints = false
        first.material = .popover
        first.state = .active
        first.isEmphasized = true
        addSubview(first)
        
        let second = NSVisualEffectView()
        second.translatesAutoresizingMaskIntoConstraints = false
        second.material = .menu
        second.state = .active
        addSubview(second)
        
        addSubview(web)
        
        first.topAnchor.constraint(equalTo: topAnchor).isActive = true
        first.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        first.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        first.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        
        second.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        second.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        second.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        second.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        top = web.topAnchor.constraint(equalTo: second.topAnchor)
        top.isActive = true
        web.leftAnchor.constraint(equalTo: second.leftAnchor).isActive = true
        web.rightAnchor.constraint(equalTo: second.rightAnchor).isActive = true
        web.bottomAnchor.constraint(equalTo: second.bottomAnchor).isActive = true
    }
    
    var findBarView: NSView? {
        didSet {
            oldValue?.removeFromSuperview()
            findBarView
                .map {
                    $0.removeFromSuperview()
                    $0.frame.size.width = 320
                    $0.frame.origin = .init(x: bounds.width - 330, y: bounds.height - ($0.frame.height + safeAreaInsets.top + 5))
                    $0.autoresizingMask = [.minXMargin, .minYMargin]
                    addSubview($0)
                }
        }
    }
    
    var isFindBarVisible = false {
        didSet {
            findBarView?
                .subviews
                .first?
                .subviews
                .filter {
                    !($0 is NSStackView)
                }
                .forEach {
                    $0.removeFromSuperview()
                }
            findBarView?.isHidden = !isFindBarVisible
            top.constant = isFindBarVisible ? 40 + safeAreaInsets.top : 0
        }
    }
    
    func findBarViewDidChangeHeight() {
        
    }
}
