import SwiftUI
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
                    cloud
                        .open(index) {
                            session.tab.browse(id, $0)
                        }
                    visible.wrappedValue.dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        if !bookmarks[index].title.isEmpty {
                            Text(verbatim: bookmarks[index].title)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Text(verbatim: bookmarks[index].access.short)
                            .foregroundColor(.secondary)
                    }
                    .font(.footnote)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(.vertical, 5)
                }
            }
            .onDelete {
                $0
                    .first
                    .map(cloud.remove(bookmark:))
            }
        }
    }
}
