import SwiftUI
import Sleuth

extension Tab.New.History {
    struct Cell: View {
        let browse: Browse
        let action: () -> Void
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                Button(action: action) {
                    VStack(alignment: .leading) {
                        if !browse.page.title.isEmpty {
                            Text(verbatim: browse.page.title)
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.primary)
                        }
                        Text(verbatim: browse.page.access.short)
                            .font(.caption2)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.secondary)
                        Text(verbatim: RelativeDateTimeFormatter().string(from: browse.date))
                            .font(.caption2)
                            .foregroundColor(.init(.secondary))
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .padding()
            }
        }
    }
}
