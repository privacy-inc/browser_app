import SwiftUI
import WidgetKit
import Sleuth

extension Search {
    struct Content: View {
        @Environment(\.widgetFamily) private var family: WidgetFamily
        
        var body: some View {
            ZStack {
                Color(.secondarySystemBackground)
                    .widgetURL(URL(string: Scheme.privacy_search.url)!)
                switch family {
                case .systemMedium:
                    HStack {
                        Spacer()
                        Link(destination: URL(string: Scheme.privacy_forget.url)!) {
                            Neumorphic(image: "flame.fill")
                        }
                        Spacer()
                        Neumorphic(image: "magnifyingglass")
                        Spacer()
                        Link(destination: URL(string: Scheme.privacy_trackers.url)!) {
                            Neumorphic(image: "shield.lefthalf.fill")
                        }
                        Spacer()
                    }
                default:
                    VStack {
                        HStack {
                            Text("Privacy")
                                .foregroundColor(.secondary)
                                .padding([.leading, .top])
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .padding([.trailing, .bottom])
                        }
                    }
                    .padding(5)
                }
            }
        }
    }
}
