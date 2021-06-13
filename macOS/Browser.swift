import AppKit

final class Browser: NSView, NSTextFinderBarContainer {
    private var top: NSLayoutConstraint!
    
    required init?(coder: NSCoder) { nil }
    init(web: Web) {
        super.init(frame: .zero)
//        material = .contentBackground
//        state = .active
        addSubview(web)
        top = web.topAnchor.constraint(equalTo: topAnchor)
        top.isActive = true
        web.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        web.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        web.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    var findBarView: NSView? {
        didSet {
            oldValue?.removeFromSuperview()
            findBarView
                .map {
                    $0.frame.size.width = 320
                    $0.frame.origin = .init(x: bounds.width - 330, y: bounds.height - ($0.frame.height + safeAreaInsets.top + 10))
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
            top.constant = isFindBarVisible ? 50 + safeAreaInsets.top : 0
        }
    }
    
    func findBarViewDidChangeHeight() {
        
    }
}
