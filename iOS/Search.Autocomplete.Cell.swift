import SwiftUI
import Sleuth

extension Search.Autocomplete {
    struct Cell: View {
        let item: Filtered
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Icon(domain: item.short)
                    Text(verbatim: item.title)
                        .foregroundColor(.primary)
                    + Text(verbatim: " - " + item.short)
                        .foregroundColor(.secondary)
                }
                .font(.footnote)
                .lineLimit(2)
                .padding(.horizontal)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            }
        }
    }
}
