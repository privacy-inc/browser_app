import AppKit

extension NSAttributedString {
    class func make(transform: (NSMutableAttributedString) -> Void) -> NSAttributedString {
        let mutable = NSMutableAttributedString()
        transform(mutable)
        return mutable
    }
    
    class func make(_ string: String, font: NSFont) -> Self {
        .init(string: string, attributes: [
                        .font: font])
    }
    
    class func make(_ string: String, font: NSFont, color: NSColor) -> Self {
        .init(string: string, attributes: [
                        .font: font,
                        .foregroundColor: color])
    }
    
    class func make(_ string: String, font: NSFont, alignment: NSTextAlignment) -> Self {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        return .init(string: string, attributes: [
                        .font: font,
                        .paragraphStyle: paragraph])
    }
    
    class func make(_ string: String, font: NSFont, color: NSColor, alignment: NSTextAlignment) -> Self {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        return .init(string: string, attributes: [
                        .font: font,
                        .foregroundColor: color,
                        .paragraphStyle: paragraph])
    }
    
    class func make(_ string: String, font: NSFont, color: NSColor, lineBreak: NSLineBreakMode) -> Self {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = lineBreak
        return .init(string: string, attributes: [
                        .font: font,
                        .foregroundColor: color,
                        .paragraphStyle: paragraph])
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
