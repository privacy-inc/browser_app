import SwiftUI
import Sleuth

extension Search.Autocomplete {
    struct Cell: View {
        let item: Filtered
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(alignment: .leading) {
                    if !item.title.isEmpty {
                        Text(verbatim: item.title)
                            .foregroundColor(.primary)
                            .padding(.top, 4)
                    }
                    if !item.url.isEmpty {
                        Text(verbatim: item.domain)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4)
                    }
                }
                .font(.footnote)
                .lineLimit(1)
                .padding(.horizontal)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            }
        }
    }
}
