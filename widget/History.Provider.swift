import WidgetKit

extension History {
    struct Provider: TimelineProvider {
        func placeholder(in: Context) -> Timeline {
            .placeholder
        }

        func getSnapshot(in context: Context, completion: @escaping (Timeline) -> ()) {
            completion(context.isPreview ? .placeholder : .current)
        }

        func getTimeline(in: Context, completion: @escaping (WidgetKit.Timeline<Timeline>) -> ()) {
            completion(.init(entries: [.current], policy: .never))
        }
    }
}
