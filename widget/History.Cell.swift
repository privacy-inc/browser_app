import SwiftUI
import Sleuth

extension History {
    struct Cell: View {
        let page: Share.Page
        
        var body: some View {
            Link(destination: page.url) {
                VStack(alignment: .leading) {
                    if !page.title.isEmpty {
                        Text(verbatim: page.title)
                            .font(.caption)
                            .lineLimit(4)
                    }
                    Text(verbatim: page.subtitle)
                        .font(.caption2)
                        .foregroundColor(.init(.tertiaryLabel))
                        .lineLimit(page.title.isEmpty ? 5 : 3)
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12)
                                .fill(Color.primary.opacity(0.03)))
            }
        }
    }
}
