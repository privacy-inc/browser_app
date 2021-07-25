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
                    VStack(alignment: .leading, spacing: 0) {
                        if !browse.page.title.isEmpty {
                            Text(verbatim: browse.page.title)
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.primary)
                        }
                        Text(verbatim: browse.page.access.short + " - " + RelativeDateTimeFormatter().string(from: browse.date))
                            .font(.caption)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.secondary)
                            .padding(.top, 3)
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .padding()
            }
        }
    }
}
