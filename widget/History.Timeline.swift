import WidgetKit
import Sleuth

extension History {
    struct Timeline: TimelineEntry {
        static let placeholder = Self(items: [], date: .distantPast)
        static let current = Self(items: Share.history, date: .init())
        
        let items: [Share.Page]
        let date: Date
    }
}
