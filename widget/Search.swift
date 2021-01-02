import WidgetKit
import SwiftUI

struct Search: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Search", provider: Provider()) { _ in
            Content()
        }
        .configurationDisplayName("Search")
        .description("Search from Home")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
