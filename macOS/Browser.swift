import AppKit

final class Browser: NSView, NSTextFinderBarContainer {
    private weak var height: NSLayoutConstraint!
    private weak var blur: NSVisualEffectView!
    
    deinit {
        print("browser gone")
    }
    
    required init?(coder: NSCoder) { nil }
    init(web: Web) {
        super.init(frame: .zero)
        wantsLayer = true
        layer!.backgroundColor = .init(gray: 0.9, alpha: 1)
        addSubview(web)
        
        let blur = NSVisualEffectView()
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.material = .underWindowBackground
        addSubview(blur)
        self.blur = blur
        
        let separator = Separator()
        blur.addSubview(separator)
        
        blur.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        height = blur.heightAnchor.constraint(equalToConstant: 0)
        height.isActive = true
        
        separator.bottomAnchor.constraint(equalTo: blur.bottomAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        web.topAnchor.constraint(equalTo: blur.bottomAnchor).isActive = true
        web.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        web.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        web.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
            height.constant = isFindBarVisible ? 40 + safeAreaInsets.top : 0
        }
    }
    
    func findBarViewDidChangeHeight() {
        
    }
}
