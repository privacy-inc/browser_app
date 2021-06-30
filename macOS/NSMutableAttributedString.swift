import Foundation

extension NSMutableAttributedString {
    func linebreak() {
        append(.init(string: "\n"))
    }
}
