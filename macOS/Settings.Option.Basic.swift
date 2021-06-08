import AppKit

extension Settings.Option {
    class Basic: Settings.Option {
        required init?(coder: NSCoder) { nil }
        override init(title: String, image: String) {
            super.init(title: title, image: image)
            text.textColor = .labelColor
            self.image.contentTintColor = .labelColor
        }
        
        override func update() {
            super.update()
            switch state {
            case .pressed:
                layer!.backgroundColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
    }
}
