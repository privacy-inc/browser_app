import Foundation

extension NumberFormatter {
    static let decimal: NumberFormatter = {
        $0.numberStyle = .decimal
        return $0
    } (NumberFormatter())
}
