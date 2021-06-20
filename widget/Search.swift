import SwiftUI
import WidgetKit

struct Search: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Search", provider: Provider(), content: Content.init(entry:))
            .configurationDisplayName("Search")
            .description("Quick search")
            .supportedFamilies([.systemSmall])
    }
}
