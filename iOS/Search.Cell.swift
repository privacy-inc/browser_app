import SwiftUI
import Sleuth

extension Search {
    struct Cell: View {
        let filtered: Filtered
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(height: 1)
                    if !filtered.title.isEmpty {
                        Text(verbatim: filtered.title)
                            .font(.footnote)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .padding(.top, 6)
                    }
                    if !filtered.url.isEmpty {
                        Text(verbatim: filtered.url)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .padding(.bottom, 6)
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            }
        }
    }
}
