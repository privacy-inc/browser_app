import SwiftUI
import WidgetKit

struct Fast: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: "Sites", intent: FastIntent.self, provider: Provider(), content: Content.init(entry:))
            .configurationDisplayName("Sites")
            .description("Quick access to your sites")
            .supportedFamilies([.systemMedium, .systemLarge])
    }
}
