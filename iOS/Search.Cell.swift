import SwiftUI

extension Search {
    struct Cell: View {
        let item: Item
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.secondarySystemFill))
                        .frame(height: 1)
                    Text(verbatim: item.title)
                        .font(.footnote)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .padding(.top, 6)
                    Text(verbatim: item.url)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .padding(.bottom, 6)
                }
                .padding(.horizontal)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            }
        }
    }
}
