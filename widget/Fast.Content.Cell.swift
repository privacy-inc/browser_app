import SwiftUI

extension Fast.Content {
    struct Cell: View {
        let item: Fast.Entry.Item
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.systemBackground))
                VStack(alignment: .leading) {
                    if !item.title.isEmpty {
                        Text(verbatim: item.title)
                            .foregroundColor(.primary)
                    }
                    Text(verbatim: item.domain)
                        .foregroundColor(.secondary)
                }
                .font(.caption2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(12)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            }
        }
    }
}
