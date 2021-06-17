import SwiftUI
import Sleuth

extension Collection {
    struct History: View {
        @Binding var session: Session
        let id: UUID
        let browse: [Browse]
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            ForEach(0 ..< browse.count, id: \.self) { index in
                Button {
                    cloud
                        .revisit(browse[index].id)
                    tabber.browse(id, browse[index].id)
                    visible.wrappedValue.dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        if !browse[index].page.title.isEmpty {
                            Text(verbatim: browse[index].page.title)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Text(verbatim: browse[index].page.access.domain)
                            .foregroundColor(.secondary)
                        Text(verbatim: RelativeDateTimeFormatter().string(from: browse[index].date))
                            .foregroundColor(.secondary)
                    }
                    .font(.footnote)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(.vertical, 3)
                }
            }
        }
    }
}
