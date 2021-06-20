import WidgetKit

extension Search {
    struct Entry: TimelineEntry, Equatable {
        static let shared = Self()

        let date = Date()
    }
}
