import Foundation

extension Bar {
    final class Button: Control {
        private(set) weak var icon: Image!
        
        required init?(coder: NSCoder) { nil }
        init(icon: String) {
            let icon = Image(icon: icon)
            icon.symbolConfiguration = .init(pointSize: 17, weight: .regular)
            self.icon = icon
            
            super.init(layer: false)
            addSubview(icon)
            
            widthAnchor.constraint(equalToConstant: 30).isActive = true
            heightAnchor.constraint(equalToConstant: 26).isActive = true
            
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed, .highlighted:
                icon.contentTintColor = .tertiaryLabelColor
            default:
                icon.contentTintColor = .secondaryLabelColor
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
