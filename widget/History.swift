import WidgetKit
import SwiftUI

struct History: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "History", provider: Provider()) { entry in
            ZStack {
                Color(.secondarySystemBackground)
//                Log(items: entry.items)
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        Image(systemName: "magnifyingglass")
//                            .font(Font.body.bold())
//                            .foregroundColor(.init("AccentColor"))
//                            .frame(width: 150, height: 40)
//                            .padding(.bottom)
//                        Spacer()
//                    }.widgetURL(URL(string: "incognit-search://")!)
//                }
            }
        }
        .configurationDisplayName("History")
        .description("Latest pages")
    }
}
