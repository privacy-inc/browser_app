import AppKit

extension NSAttributedString {
    class func make(transform: (NSMutableAttributedString) -> Void) -> NSAttributedString {
        let mutable = NSMutableAttributedString()
        transform(mutable)
        return mutable
    }
    
    func height(for width: CGFloat) -> CGFloat {
        CTFramesetterSuggestFrameSizeWithConstraints(
            CTFramesetterCreateWithAttributedString(self),
            CFRange(),
            nil,
            .init(width: width,
                  height: .greatestFiniteMagnitude),
            nil)
            .height
    }
}

extension NSMutableAttributedString {
    func linebreak() {
        append(.init(string: "\n"))
    }
    
    func add(_ string: String, font: NSFont, color: NSColor) {
        append(.init(string: string, attributes: [
                        .font: font,
                        .foregroundColor: color]))
    }
}
