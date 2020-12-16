import AppKit

final class Tabbar: NSView {
    
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = effectiveAppearance == NSAppearance(named: .darkAqua) ? .init(gray: 0, alpha: 0.3) : .init(gray: 0, alpha: 0.05)
        
        heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
}
