import SwiftUI
import Archivable
import Sleuth

extension Collection {
    struct History: View {
        @Binding var session: Session
        let id: UUID
        let browse: [Browse]
        let dismiss: () -> Void
        
        var body: some View {
            ForEach(0 ..< browse.count, id: \.self) { index in
                Button {
                    Cloud.shared.revisit(browse[index].id)
                    session.tab.browse(id, browse[index].id)
                    dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        if !browse[index].page.title.isEmpty {
                            Text(verbatim: browse[index].page.title)
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Text(verbatim: browse[index].page.access.domain)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(verbatim: RelativeDateTimeFormatter().string(from: browse[index].date))
                            .font(.caption2)
                            .foregroundColor(.init(.tertiaryLabel))
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(.vertical, 3)
                }
            }
        }
    }
}