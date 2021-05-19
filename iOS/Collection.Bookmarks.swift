import SwiftUI
import Archivable
import Sleuth

extension Collection {
    struct Bookmarks: View, Tabber {
        @Binding var session: Session
        let id: UUID
        let bookmarks: [Page]
        let dismiss: () -> Void
        
        var body: some View {
            ForEach(0 ..< bookmarks.count, id: \.self) { index in
                Button {
                    Cloud.shared.open(index, id: browse) {
                        if browse == $0 {
                            session.load.send((id, $1))
                        } else {
                            session.tab.browse(id, $0)
                        }
                    }
                    dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        if !bookmarks[index].title.isEmpty {
                            Text(bookmarks[index].title)
                                .font(.callout)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Text(bookmarks[index].domain)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(.vertical, 5)
                }
            }
        }
    }
}
