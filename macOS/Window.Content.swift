import AppKit

extension Window {
    final class Content: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            let bar = NSVisualEffectView()
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.material = .popover
            bar.state = .active
            bar.isEmphasized = true
            addSubview(bar)
            
            let separator = Separator(mode: .horizontal)
            bar.addSubview(separator)
            
            bar.topAnchor.constraint(equalTo: topAnchor).isActive = true
            bar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            bar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            bar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 1).isActive = true
            
            separator.bottomAnchor.constraint(equalTo: bar.bottomAnchor).isActive = true
            separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
        
        var display: NSView? {
            didSet {
                oldValue?.removeFromSuperview()
                display
                    .map {
                        addSubview($0)
                        
                        $0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 1).isActive = true
                        $0.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                        $0.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
                        $0.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
                    }
            }
        }
    }
}
