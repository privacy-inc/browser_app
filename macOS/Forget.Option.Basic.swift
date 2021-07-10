import AppKit

extension Forget.Option {
    final class Basic: Forget.Option {
        required init?(coder: NSCoder) { nil }
        override init(title: String, image: String) {
            super.init(title: title, image: image)
            text.textColor = .secondaryLabelColor
            self.image.contentTintColor = .secondaryLabelColor
        }
    }
}
