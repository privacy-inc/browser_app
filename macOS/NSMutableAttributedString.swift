import AppKit

extension NSMutableAttributedString {
    func linebreak() {
        append(.init(string: "\n"))
    }
}
