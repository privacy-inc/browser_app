import WidgetKit
import Sleuth

extension History {
    struct Timeline: TimelineEntry {
        static var current: Self { .init(pages: Share.history, date: .init()) }
        static let placeholder = Self(pages: [], date: .distantPast)
        
        let pages: [Share.Page]
        let date: Date
    }
}
