import SwiftUI
import Sleuth

extension Tab.New.History {
    struct Cell: View {
        let browse: Browse
        let action: () -> Void
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.tertiarySystemFill))
                Button(action: action) {
                    VStack(alignment: .leading) {
                        Text(verbatim: RelativeDateTimeFormatter().string(from: browse.date))
                            .font(.caption2)
                            .foregroundColor(.init(.secondary))
                        if !browse.page.title.isEmpty {
                            Text(verbatim: browse.page.title)
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.primary)
                        }
                        Text(verbatim: browse.page.access.domain)
                            .font(.caption2)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.init(.tertiaryLabel))
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .padding()
            }
        }
    }
}
