import SwiftUI

extension Fast.Content {
    struct Cell: View {
        let item: Fast.Entry.Item
        
        var body: some View {
            Link(destination: URL(string: "privacy://\(item.sites == .bookmarks ? "bookmark" : "history")/\(item.id)")!) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.systemBackground))
                    VStack(alignment: .leading) {
                        if !item.title.isEmpty {
                            Text(verbatim: item.title)
                                .lineLimit(3)
                                .foregroundColor(.primary)
                        }
                        Text(verbatim: item.short)
                            .lineLimit(item.title.isEmpty ? 3 : 1)
                            .foregroundColor(.secondary)
                    }
                    .font(.caption2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(10)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
            }
        }
    }
}
