import AppKit

final class Browser: NSVisualEffectView, NSTextFinderBarContainer {
    private weak var top: NSLayoutConstraint!
    private weak var separator: Separator!
    
    deinit {
        print("browser gone")
    }
    
    required init?(coder: NSCoder) { nil }
    init(web: Web) {
        super.init(frame: .zero)
        material = .underWindowBackground
        addSubview(web)
        
        let separator = Separator()
        separator.isHidden = true
        addSubview(separator)
        self.separator = separator
        
        top = web.topAnchor.constraint(equalTo: topAnchor)
        top.isActive = true
        web.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        web.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        web.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        separator.bottomAnchor.constraint(equalTo: web.topAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
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
            separator.isHidden = !isFindBarVisible
            top.constant = isFindBarVisible ? 40 + safeAreaInsets.top : 0
        }
    }
    
    func findBarViewDidChangeHeight() {
        
    }
    
    override var allowsVibrancy: Bool {
        true
    }
}
