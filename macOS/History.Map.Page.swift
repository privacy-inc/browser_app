import AppKit
import Sleuth

extension History.Map {
    struct Page {
        let page: Sleuth.Page
        let text: NSAttributedString
        
        init(page: Sleuth.Page) {
            self.page = page
            text = {
                $0.append(.init(string:
                                    RelativeDateTimeFormatter().localizedString(for: page.date, relativeTo: .init()) + "\n", attributes: [
                                        .font : NSFont.systemFont(ofSize: 12, weight: .regular),
                                        .foregroundColor : NSColor.secondaryLabelColor]))

                if !page.title.isEmpty {
                    $0.append(.init(string: page.title + "\n", attributes: [
                                            .font : NSFont.systemFont(ofSize: 14, weight: .regular),
                                            .foregroundColor : NSColor.labelColor]))
                }
                $0.append(.init(string: {
                    $0.count > Metrics.history.url
                        ? page.title.isEmpty
                            ? $0
                            : .init($0.prefix(Metrics.history.url - 3)) + "..."
                        : $0
                } (page.url.absoluteString), attributes: [
                                        .font : NSFont.systemFont(ofSize: 12, weight: .regular),
                                        .foregroundColor : NSColor.tertiaryLabelColor]))
                return $0
            } (NSMutableAttributedString())
        }
    }
}
