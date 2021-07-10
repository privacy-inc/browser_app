import AppKit

extension Forget.Option {
    final class Destructive: Forget.Option {
        required init?(coder: NSCoder) { nil }
        override init(title: String, image: String) {
            super.init(title: title, image: image)
            text.textColor = .labelColor
            self.image.contentTintColor = .labelColor
        }
    }
}
