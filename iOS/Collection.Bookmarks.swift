import SwiftUI
import Archivable
import Sleuth

extension Collection {
    struct Bookmarks: View {
        @Binding var session: Session
        let id: UUID
        let bookmarks: [Page]
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            ForEach(0 ..< bookmarks.count, id: \.self) { index in
                Button {
                    Cloud.shared.open(index, id: session.tab.state(id).browse) {
                        if session.tab.state(id).browse == $0 {
                            session.load.send((id: id, access: $1))
                        } else {
                            session.tab.browse(id, $0)
                        }
                    }
                    visible.wrappedValue.dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        if !bookmarks[index].title.isEmpty {
                            Text(verbatim: bookmarks[index].title)
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Text(verbatim: bookmarks[index].access.domain)
                            .font(.caption2.bold())
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(.vertical, 5)
                }
            }
        }
    }
}
