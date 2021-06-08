import AppKit

extension NSFont {
    class func font(style: TextStyle, weight: Weight) -> NSFont {
        .systemFont(ofSize: NSFont.preferredFont(forTextStyle: style).pointSize, weight: weight)
    }
    
    class func monoDigit(style: TextStyle, weight: Weight) -> NSFont {
        .monospacedDigitSystemFont(ofSize: NSFont.preferredFont(forTextStyle: style).pointSize, weight: weight)
    }
}
