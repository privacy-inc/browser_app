import WidgetKit
import SwiftUI

struct History: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "History", provider: Provider()) { entry in
            Content(pages: entry.pages)
        }
        .configurationDisplayName("History")
        .description("Quick access to your history")
    }
}
