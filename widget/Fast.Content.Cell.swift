import SwiftUI

extension Fast.Content {
    struct Cell: View {
        let item: Fast.Entry.Item
        
        var body: some View {
            Link(destination: URL(string: "privacy://\(item.sites == .bookmarks ? "bookmark" : "history")/\(item.id)")!) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.systemBackground))
                    Group() {
                        Text(verbatim: item.title)
                            .foregroundColor(.primary)
                        + Text(verbatim: " - " + item.short)
                            .foregroundColor(.secondary)
                    }
                    .lineLimit(4)
                    .font(.caption2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(10)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                
            }
        }
    }
}
