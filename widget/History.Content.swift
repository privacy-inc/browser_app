import SwiftUI
import WidgetKit
import Sleuth

extension History {
    struct Content: View {
        let pages: [Share.Page]
        @Environment(\.widgetFamily) private var family: WidgetFamily
        
        var body: some View {
            ZStack {
                Color(white: 0.125)
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
                            HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                    Cell(page: pages.first!, align: .leading)
                                        .frame(width: geo.size.width * 0.5)
                                    if pages.count > 2 {
                                        Cell(page: pages[2], align: .leading)
                                            .frame(width: geo.size.width * 0.5)
                                            .padding(.top)
                                        if pages.count > 4 {
                                            Cell(page: pages[4], align: .leading)
                                                .frame(width: geo.size.width * 0.5)
                                                .padding(.top)
                                        }
                                    }
                                    Spacer()
                                }
                                if pages.count > 1 {
                                    VStack(spacing: 0) {
                                        Cell(page: pages[1], align: .trailing)
                                            .frame(width: geo.size.width * 0.5)
                                        if pages.count > 3 {
                                            Cell(page: pages[3], align: .trailing)
                                                .frame(width: geo.size.width * 0.5)
                                                .padding(.top)
                                            if pages.count > 5 {
                                                Cell(page: pages[5], align: .trailing)
                                                    .frame(width: geo.size.width * 0.5)
                                                    .padding(.top)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .multilineTextAlignment(.trailing)
                                } else {
                                    Spacer()
                                }
                            }
                        case .systemMedium:
                            HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                    Spacer()
                                    Cell(page: pages.first!, align: .leading)
                                        .frame(width: geo.size.width * 0.5)
                                    Spacer()
                                }
                                if pages.count > 1 {
                                    VStack(spacing: 0) {
                                        Spacer()
                                        Cell(page: pages[1], align: .trailing)
                                            .frame(width: geo.size.width * 0.5)
                                        Spacer()
                                    }
                                    .multilineTextAlignment(.trailing)
                                } else {
                                    Spacer()
                                }
                            }
                        default:
                            VStack {
                                Spacer()
                                Cell(page: pages.first!, align: .leading)
                                Spacer()
                            }
                        }
                    }
                    .padding(25)
                }
            }
        }
    }
}
