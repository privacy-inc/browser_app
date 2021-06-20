import WidgetKit

extension Search {
    struct Entry: TimelineEntry {
        static let shared = Self()

        let date = Date()
    }
}
