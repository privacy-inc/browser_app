import WidgetKit

extension Fast {
    struct Entry: TimelineEntry {
        static let placeholder = Entry(sites: [
                                        [.init(id: 0,
                                               sites: .history,
                                               title: "Google Search",
                                               short: "google"),
                                         .init(id: 0,
                                               sites: .history,
                                               title: "Ecosia Search",
                                               short: "ecosia")],
                                        [.init(id: 0,
                                               sites: .history,
                                               title: "Wikipedia",
                                               short: "wikipedia")]], date: .init())
        
        let sites: [[Item]]
        let date: Date
    }
}
