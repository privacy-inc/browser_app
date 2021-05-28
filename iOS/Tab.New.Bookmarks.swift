import SwiftUI
import Sleuth

extension Tab.New {
    struct Bookmarks: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            ForEach(0 ..< list.count, id: \.self) { index in
                Rectangle()
                    .fill(Color(.secondarySystemFill))
                    .frame(height: 1)
                    .padding(.horizontal)
                Button {
                    let browse = session.tab.state(id).browse
                    cloud
                        .open(index, id: browse) {
                            if browse == $0 {
                                session.load.send((id: id, access: $1))
                            } else {
                                tabber.browse(id, $0)
                            }
                        }
                } label: {
                    VStack(alignment: .leading) {
                        Text(verbatim: list[index].title)
                            .font(.footnote)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(verbatim: list[index].access.domain)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
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
