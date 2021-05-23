import SwiftUI
import Archivable

struct Search: View {
    @Binding var session: Session
    let id: UUID
    @State private var filter = ""
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                Text("Bookmarks")
                    .font(.footnote.bold())
                    .foregroundColor(.accentColor)
                    .padding([.top, .leading])
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                ForEach(bookmarks, id: \.self, content: cell)
                Text("Recent")
                    .font(.footnote.bold())
                    .foregroundColor(.accentColor)
                    .padding(.leading)
                    .padding(.top, 30)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                ForEach(recent, id: \.self, content: cell)
                Spacer()
            }
            Bar(session: $session, filter: $filter, id: id)
                .frame(height: 0)
        }
    }
    
    private func cell(_ item: Item) -> Cell {
        .init(item: item) {
            Cloud.shared.browse(item.url, id: session.tab.state(id).browse) {
                UIApplication.shared.resign()
                if session.tab.state(id).browse == $0 {
                    session.load.send((id: id, access: $1))
                } else {
                    session.tab.browse(id, $0)
                }
            }
        }
    }
    
    private var bookmarks: [Item] {
        filter.isEmpty
            ? .init(session
                        .archive
                        .bookmarks
                        .prefix(2)
                        .map(Item.init(page:)))
            : .init(Set(session
                            .archive
                            .bookmarks
                            .filter {
                                $0.title.localizedCaseInsensitiveContains(filter)
                                    || $0.access.string.localizedCaseInsensitiveContains(filter)
                            }
                            .map(Item.init(page:)))
                            .sorted()
                            .prefix(2))
    }
    
    private var recent: [Item] {
        filter.isEmpty
            ? .init(session
                        .archive
                        .browse
                        .filter {
                            switch $0.page.access {
                            case .remote:
                                return true
                            default:
                                return false
                            }
                        }
                        .prefix(3)
                        .map(\.page)
                        .map(Item.init(page:)))
            : .init(Set(session
                            .archive
                            .browse
                            .filter {
                                switch $0.page.access {
                                case .remote:
                                    return true
                                default:
                                    return false
                                }
                            }
                            .filter {
                                $0.page.title.localizedCaseInsensitiveContains(filter)
                                    || $0.page.access.string.localizedCaseInsensitiveContains(filter)
                            }
                            .sorted {
                                $0.date < $1.date
                            }
                            .map(\.page)
                            .map(Item.init(page:)))
                            .prefix(3))
    }
}
