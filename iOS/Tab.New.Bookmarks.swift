import SwiftUI
import Archivable
import Sleuth

extension Tab.New {
    struct Bookmarks: View, Tabber {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            ForEach(0 ..< list.count, id: \.self) { index in
                if index != 0 {
                    Rectangle()
                        .fill(Color(.secondarySystemFill))
                        .frame(height: 1)
                        .padding(.horizontal)
                }
                Button {
                    Cloud.shared.open(index, id: browse) {
                        if browse == $0 {
                            session.load.send(id)
                        } else {
                            session.tab.browse(id, $0)
                        }
                    }
                } label: {
                    VStack(alignment: .leading) {
                        Text(list[index].title)
                            .font(.footnote)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(list[index].domain)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .contentShape(Rectangle())
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
            }
        }
        
        private var list: [Page] {
            .init(session
                    .archive
                    .bookmarks
                    .prefix(3))
        }
    }
}
