import AppKit

final class Capsule: Control {
    required init?(coder: NSCoder) { nil }
    init(title: String) {
        super.init()
        layer!.cornerRadius = 18
        layer!.backgroundColor = NSColor.controlAccentColor.cgColor
        
        let text = Text()
        text.stringValue = title
        text.font = .systemFont(ofSize: 14, weight: .medium)
        text.textColor = .white
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(text)
        
        heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        text.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 30).isActive = true
        text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -30).isActive = true
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    override func update() {
        switch state {
        case .highlighted:
            alphaValue = 0.9
        case .pressed:
            alphaValue = 0.7
        default:
            alphaValue = 1
        }
    }
}
