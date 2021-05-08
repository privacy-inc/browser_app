import SwiftUI
import WidgetKit
import Sleuth

extension History {
    struct Content: View {
        let entries: [Entry]
        @Environment(\.widgetFamily) private var family: WidgetFamily
        
        var body: some View {
            ZStack {
                Color(.systemBackground)
//                    .widgetURL(URL(string: Scheme.privacy_search.url)!)
                if entries.isEmpty {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Placeholder()
                                .padding()
                            Spacer()
                        }
                        Spacer()
                    }
                } else {
                    GeometryReader { geo in
                        HStack(alignment: .top, spacing: 0) {
                            VStack(spacing: 6) {
                                Cell(entry: entries.first!)
                                if entries.count > 2 {
                                    Cell(entry: entries[2])
                                    if entries.count > 4 {
                                        Cell(entry: entries[4])
                                        if entries.count > 6 {
                                            Cell(entry: entries[6])
                                        }
                                    }
                                }
                            }
                            .frame(width: family == .systemSmall ? geo.size.width : (geo.size.width * 0.5) - 6)
                            if family != .systemSmall, entries.count > 1 {
                                VStack(spacing: 6) {
                                    Cell(entry: entries[1])
                                    if entries.count > 3 {
                                        Cell(entry: entries[3])
                                        if entries.count > 5 {
                                            Cell(entry: entries[5])
                                            if entries.count > 7 {
                                                Cell(entry: entries[7])
                                            }
                                        }
                                    }
                                }
                                .frame(width: (geo.size.width * 0.5) - 6)
                                .padding(.leading, 6)
                            } else {
                                Spacer()
                            }
                        }
                    }
                    .padding([.leading, .top, .trailing], 20)
                }
            }
        }
    }
}
