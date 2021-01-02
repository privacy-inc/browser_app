import WidgetKit
import Sleuth

extension History {
    struct Timeline: TimelineEntry {
        static let placeholder = Self(pages: [], date: .distantPast)
        static let current = Self(pages: Share.history, date: .init())
        
        let pages: [Share.Page]
        let date: Date
    }
}
