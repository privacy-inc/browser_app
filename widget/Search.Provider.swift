import WidgetKit
import Sleuth

extension Search {
    struct Provider: TimelineProvider {
        func placeholder(in: Context) -> Timeline {
            .init()
        }

        func getSnapshot(in context: Context, completion: @escaping (Timeline) -> ()) {
            completion(.init())
        }

        func getTimeline(in: Context, completion: @escaping (WidgetKit.Timeline<Timeline>) -> ()) {
            completion(.init(entries: [.init()], policy: .never))
        }
    }
}
