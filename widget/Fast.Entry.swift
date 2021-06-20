import WidgetKit

extension Fast {
    struct Entry: TimelineEntry {
        static let placeholder = Entry(sites: [
                                        [.init(id: 0,
                                               sites: .history,
                                               title: "Google Search",
                                               domain: "google.com"),
                                         .init(id: 0,
                                               sites: .history,
                                               title: "Ecosia Search",
                                               domain: "ecosia.org")],
                                        [.init(id: 0,
                                               sites: .history,
                                               title: "Wikipedia",
                                               domain: "wikipedia.org")]], date: .init())
        
        let sites: [[Item]]
        let date: Date
    }
}
