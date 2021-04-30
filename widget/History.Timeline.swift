import WidgetKit
import Sleuth

extension History {
    struct Timeline: TimelineEntry {
        static var current: Self { .init(entries: [], date: .init()) }
        static let placeholder = Self(entries: [], date: .distantPast)
        
        let entries: [Entry]
        let date: Date
    }
}
