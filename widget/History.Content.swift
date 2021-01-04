import SwiftUI
import WidgetKit
import Sleuth

extension History {
    struct Content: View {
        let pages: [Share.Page]
        @Environment(\.widgetFamily) private var family: WidgetFamily
        
        var body: some View {
            ZStack {
                Color("WidgetBackground")
                    .opacity(0.6)
                    .widgetURL(URL(string: Scheme.privacy_search.url)!)
                if pages.isEmpty {
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
                        switch family {
                        case .systemLarge:
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    Cell(page: pages.first!)
                                        .frame(width: geo.size.width * 0.45)
                                    if pages.count > 2 {
                                        Spacer()
                                        Cell(page: pages[2])
                                            .frame(width: geo.size.width * 0.45)
                                        if pages.count > 4 {
                                            Spacer()
                                            Cell(page: pages[4])
                                                .frame(width: geo.size.width * 0.45)
                                        }
                                    }
                                    Spacer()
                                }
                                Spacer()
                                VStack {
                                    Spacer()
                                    if pages.count > 1 {
                                        Cell(page: pages[1])
                                            .frame(width: geo.size.width * 0.45)
                                    }
                                    if pages.count > 3 {
                                        Spacer()
                                        Cell(page: pages[3])
                                            .frame(width: geo.size.width * 0.45)
                                        if pages.count > 5 {
                                            Spacer()
                                            Cell(page: pages[5])
                                                .frame(width: geo.size.width * 0.45)
                                        }
                                    }
                                    Spacer()
                                }
                                Spacer()
                            }
                        case .systemMedium:
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Cell(page: pages.first!)
                                        .frame(width: geo.size.width * 0.45)
                                    if pages.count > 1 {
                                        Spacer()
                                        Cell(page: pages[1])
                                            .frame(width: geo.size.width * 0.45)
                                    }
                                    Spacer()
                                }
                                Spacer()
                            }
                        default:
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    Cell(page: pages.first!)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
    }
}
