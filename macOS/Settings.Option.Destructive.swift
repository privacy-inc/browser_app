import AppKit

extension Settings.Option {
    final class Destructive: Settings.Option {
        required init?(coder: NSCoder) { nil }
        override init(title: String, image: String) {
            super.init(title: title, image: image)
            text.textColor = .white
            self.image.contentTintColor = .white
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                layer!.backgroundColor = .init(gray: 0, alpha: 1)
            case .highlighted:
                layer!.backgroundColor = .init(gray: 0, alpha: 0.6)
            default:
                layer!.backgroundColor = .init(gray: 0, alpha: 0.4)
            }
        }
    }
}
