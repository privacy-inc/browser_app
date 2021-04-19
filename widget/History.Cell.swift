import SwiftUI
import Sleuth

extension History {
    struct Cell: View {
        let page: Share.Page
        
        var body: some View {
            Link(destination: page.url) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.primary.opacity(0.04))
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
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding()
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
