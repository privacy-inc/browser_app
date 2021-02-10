import WidgetKit
import SwiftUI

struct Search: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Search", provider: Provider()) { _ in
            Content()
                .colorScheme(.dark)
        }
        .configurationDisplayName("Search")
        .description("Search from Home")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
