import SwiftUI
import Sleuth

extension History {
    struct Cell: View {
        let page: Share.Page
        let align: HorizontalAlignment
        
        var body: some View {
            Link(destination: page.url) {
                HStack {
                    if align == .trailing {
                        Spacer()
                    }
                    VStack(alignment: align) {
                        if !page.title.isEmpty {
                            Text(verbatim: page.title)
                                .lineLimit(3)
                                .font(.footnote)
                        }
                        Text(verbatim: page.subtitle)
                            .lineLimit(3)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    if align == .leading {
                        Spacer()
                    }
                }
            }
        }
    }
}
