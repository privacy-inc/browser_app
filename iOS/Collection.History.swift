import SwiftUI
import Sleuth

extension Collection {
    struct History: View {
        @Binding var session: Session
        let id: UUID
        let browses: [Browse]
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            ForEach(0 ..< browses.count, id: \.self) { index in
                Button {
                    cloud
                        .revisit(browses[index].id)
                    session.tab.browse(id, browses[index].id)
                    visible.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Icon(domain: browses[index].page.access.short)
                        Text(verbatim: browses[index].page.title)
                            .foregroundColor(.primary)
                            .font(.footnote) +
                        Text(verbatim: " : " + browses[index].page.access.short + " - " + RelativeDateTimeFormatter().string(from: browses[index].date))
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 8)
                }
            }
            .onDelete {
                $0
                    .first
                    .map {
                        browses[$0].id
                    }
                    .map(cloud.remove(browse:))
            }
        }
    }
}
