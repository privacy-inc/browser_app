import WidgetKit
import SwiftUI

struct History: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "History", provider: Provider()) { entry in
            Content(entries: entry.entries)
        }
        .configurationDisplayName("History")
        .description("Quick access to your history")
    }
}
