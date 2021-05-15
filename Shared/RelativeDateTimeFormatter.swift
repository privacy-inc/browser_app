import Foundation

extension RelativeDateTimeFormatter {
    func string(from: Date, to: Date) -> String {
        Calendar.current.dateComponents([.minute], from: from, to: to).minute! > 0
            ? localizedString(for: from, relativeTo: to)
            : NSLocalizedString("Just now", comment: "")
    }
}
