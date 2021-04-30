import SwiftUI
import Sleuth

extension History {
    struct Cell: View {
        let entry: Entry
        
        var body: some View {
            Link(destination: entry.access!) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.primary.opacity(0.04))
                    VStack(alignment: .leading) {
                        if !entry.title.isEmpty {
                            Text(verbatim: entry.title)
                                .font(.caption)
                                .lineLimit(4)
                        }
                        Text(verbatim: entry.url)
                            .font(.caption2)
                            .foregroundColor(.init(.tertiaryLabel))
                            .lineLimit(entry.title.isEmpty ? 5 : 3)
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding()
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
