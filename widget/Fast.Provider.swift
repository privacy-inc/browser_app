import WidgetKit
import Sleuth

extension Fast {
    struct Provider: IntentTimelineProvider {
        func placeholder(in: Context) -> Entry {
            .placeholder
        }

        func getSnapshot(for: FastIntent, in: Context, completion: @escaping (Entry) -> ()) {
            completion(.placeholder)
        }

        func getTimeline(for intent: FastIntent, in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            guard let archive = Defaults.archive else {
                return completion(.init(entries: [.placeholder], policy: .never))
            }
            let items = intent.sites == .bookmarks
                ? archive
                    .bookmarks
                    .prefix(10)
                    .enumerated()
                    .map {
                        Entry.Item(id: $0.0, sites: .bookmarks, title: $0.1.title, short: $0.1.access.short)
                    }
                : archive
                    .browses
                    .prefix(10)
                    .map {
                        .init(id: $0.id, sites: .history, title: $0.page.title, short: $0.page.access.short)
                    }
            completion(.init(entries: [.init(
                                        sites: items
                                            .reduce(into: (Array(repeating: [], count: 2), 1)) {
                                                $0.1 = $0.1 == 1 ? 0 : 1
                                                $0.0[$0.1].append($1)
                                            }
                                            .0,
                                        date: .init())],
                             policy: .never))
        }
    }
}
