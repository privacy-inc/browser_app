import SwiftUI
import WidgetKit
import Sleuth

extension Search {
    struct Content: View {
        @Environment(\.widgetFamily) private var family: WidgetFamily
        
        var body: some View {
            ZStack {
                Color("AccentColor")
                    .widgetURL(URL(string: Scheme.privacy_search.url)!)
                switch family {
                case .systemMedium:
                    HStack {
                        Spacer()
                        Link(destination: URL(string: Scheme.privacy_forget.url)!) {
                            Neumorphic(image: "flame")
                        }
                        Spacer()
                        Neumorphic(image: "magnifyingglass")
                        Spacer()
                    }
                default:
                    Neumorphic(image: "magnifyingglass")
                }
            }
            .font(Font.largeTitle.bold())
            .foregroundColor(.black)
        }
    }
}
