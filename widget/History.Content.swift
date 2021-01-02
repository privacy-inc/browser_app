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
                    switch family {
                    case .systemLarge:
                        Large {
                            Medium {
                                Placeholder()
                                Placeholder()
                            }
                            Medium {
                                Placeholder()
                                Placeholder()
                            }
                            Medium {
                                Placeholder()
                                Placeholder()
                            }
                        }
                    case .systemMedium:
                        Medium {
                            Placeholder()
                            Placeholder()
                        }
                    default:
                        Placeholder()
                            .padding()
                    }
                } else {
                    switch family {
                    case .systemLarge:
                        Large {
                            Medium {
                                Cell(page: pages.first!)
                                if pages.count > 1 {
                                    Cell(page: pages[1])
                                }
                            }
                            if pages.count > 2 {
                                Medium {
                                    Cell(page: pages[2])
                                    if pages.count > 3 {
                                        Cell(page: pages[4])
                                    }
                                }
                                if pages.count > 4 {
                                    Medium {
                                        Cell(page: pages[4])
                                        if pages.count > 5 {
                                            Cell(page: pages[5])
                                        }
                                    }
                                }
                            }
                        }
                    case .systemMedium:
                        Medium {
                            Cell(page: pages.first!)
                            if pages.count > 1 {
                                Cell(page: pages[1])
                            }
                        }
                    default:
                        Cell(page: pages.first!)
                            .padding()
                    }
                }
            }
        }
    }
}
