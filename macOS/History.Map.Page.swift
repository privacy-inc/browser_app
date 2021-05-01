import AppKit
import Sleuth

extension History.Map {
    struct Page {
        let entry: Int
        let text: NSAttributedString
        
        init(entry: Entry) {
            self.entry = entry.id
            text = {
                $0.append(.init(string:
                                    RelativeDateTimeFormatter().string(from: entry.date, to: .init()) + "\n", attributes: [
                                        .font : NSFont.systemFont(ofSize: 12, weight: .regular),
                                        .foregroundColor : NSColor.secondaryLabelColor]))

                if !entry.title.isEmpty {
                    $0.append(.init(string: entry.title + "\n", attributes: [
                                            .font : NSFont.systemFont(ofSize: 14, weight: .regular),
                                            .foregroundColor : NSColor.labelColor]))
                }
                $0.append(.init(string: {
                    entry.url.count > Metrics.history.url
                        ? entry.title.isEmpty
                            ? entry.url
                            : .init(entry.url.prefix(Metrics.history.url - 3)) + "..."
                        : entry.url
                } (), attributes: [
                                        .font : NSFont.systemFont(ofSize: 12, weight: .regular),
                                        .foregroundColor : NSColor.tertiaryLabelColor]))
                return $0
            } (NSMutableAttributedString())
        }
    }
}
