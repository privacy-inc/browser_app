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
                    .widgetURL(URL(string: Scheme.privacy_search.url)!)
                if pages.isEmpty {
                    
                } else {
                    GeometryReader { geo in
                        switch family {
                        case .systemLarge:
                            HStack {
                                VStack {
                                    Spacer()
                                    Cell(page: pages.first!)
                                        .frame(width: geo.size.width * 0.45)
                                    if pages.count > 2 {
                                        Cell(page: pages[2])
                                            .frame(width: geo.size.width * 0.45)
                                            .padding(.top)
                                        if pages.count > 4 {
                                            Cell(page: pages[4])
                                                .frame(width: geo.size.width * 0.45)
                                                .padding(.top)
                                        }
                                    }
                                    Spacer()
                                }
                                VStack {
                                    Spacer()
                                    if pages.count > 1 {
                                        Cell(page: pages[1])
                                            .frame(width: geo.size.width * 0.45)
                                    }
                                    if pages.count > 3 {
                                        Cell(page: pages[3])
                                            .frame(width: geo.size.width * 0.45)
                                            .padding(.top)
                                        if pages.count > 5 {
                                            Cell(page: pages[5])
                                                .frame(width: geo.size.width * 0.45)
                                                .padding(.top)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            .padding()
                        case .systemMedium:
                            VStack {
                                Spacer()
                                HStack {
                                    Cell(page: pages.first!)
                                        .frame(width: geo.size.width * 0.45)
                                    if pages.count > 1 {
                                        Cell(page: pages[1])
                                            .frame(width: geo.size.width * 0.45)
                                    }
                                }
                                .padding()
                                Spacer()
                            }
                        default:
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    Cell(page: pages.first!)
                                        .padding()
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
