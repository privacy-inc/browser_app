import WidgetKit

extension Search {
    struct Provider: TimelineProvider {
        func placeholder(in: Context) -> Entry {
            .shared
        }

        func getSnapshot(in: Context, completion: @escaping (Entry) -> ()) {
            completion(.shared)
        }

        func getTimeline(in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            completion(.init(entries: [.shared], policy: .never))
        }
    }
}
