import SwiftUI
import Archivable
import Sleuth

extension Collection {
    struct Bookmarks: View {
        @Binding var session: Session
        let bookmarks: [Page]
        let dismiss: () -> Void
        
        var body: some View {
            ForEach(0 ..< bookmarks.count, id: \.self) { index in
                Button {
                    id
                        .map { id in
                            Cloud.shared.open(index, id: browse) {
                                if browse == $0 {
                                    session.load.send(id)
                                } else {
                                    session.tab.browse(id, $0)
                                }
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
        
        private var id: UUID? {
            switch session.section {
            case let .tab(id):
                return id
            default:
                return nil
            }
        }
        
        private var browse: Int? {
            id
                .flatMap {
                    switch session.tab.state($0) {
                    case let .browse(browse), let .error(browse, _):
                        return browse
                    default:
                        return nil
                    }
                }
        }
    }
}
