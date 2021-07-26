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
                        HStack(alignment: .top) {
                            Icon(domain: browse.page.access.short)
                            Text(verbatim: browse.page.access.short + " - " + RelativeDateTimeFormatter().string(from: browse.date))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        if !browse.page.title.isEmpty {
                            Text(verbatim: browse.page.title)
                                .foregroundColor(.primary)
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .padding()
            }
        }
    }
}
