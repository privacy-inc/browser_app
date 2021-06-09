import AppKit

extension Web {
    final class Bar: NSView, NSTextFinderBarContainer {
        private var height: NSLayoutConstraint!
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            wantsLayer = true
            layer!.backgroundColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
            
            height = heightAnchor.constraint(equalToConstant: 0)
            height.isActive = true
        }
        
        override var frame: NSRect {
            didSet {
                position()
            }
        }
        
        var findBarView: NSView? {
            didSet {
                subviews
                    .forEach {
                        $0.removeFromSuperview()
                    }
                findBarView
                    .map {
                        addSubview($0)
                    }
                position()
            }
        }
        
        var isFindBarVisible = true {
            didSet {
                findBarView
                    .map {
                        height.constant = isFindBarVisible ? 2 + $0.frame.height : 0
                    }
                NSAnimationContext
                    .runAnimationGroup {
                        $0.allowsImplicitAnimation = true
                        $0.duration = 0.5
                        layoutSubtreeIfNeeded()
                    }
            }
        }
        
        func findBarViewDidChangeHeight() {
            findBarView
                .map {
                    height.constant = 2 + $0.frame.height
                }
            position()
        }
        
        private func position() {
            findBarView
                .map {
                    $0.frame.size.width = frame.width
                    $0.frame.origin.y = 1
                }
        }
    }
}
