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
                    tabber.browse(id, browses[index].id)
                    visible.wrappedValue.dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        if !browses[index].page.title.isEmpty {
                            Text(verbatim: browses[index].page.title)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Text(verbatim: browses[index].page.access.domain)
                            .foregroundColor(.secondary)
                        Text(verbatim: RelativeDateTimeFormatter().string(from: browses[index].date))
                            .foregroundColor(.secondary)
                    }
                    .font(.footnote)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(.vertical, 3)
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
