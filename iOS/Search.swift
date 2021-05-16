import SwiftUI
import Archivable

struct Search: View, Tabber {
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
                    .foregroundColor(.secondary)
                    .padding([.top, .leading])
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Text("Recent")
                    .font(.footnote.bold())
                    .foregroundColor(.secondary)
                    .padding([.top, .leading])
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                ForEach(items, id: \.self) { item in
                    Cell(item: item) {
                        Cloud.shared.browse(item.url, id: browse) {
                            UIApplication.shared.resign()
                            if browse == $0 {
                                session.load.send(id)
                            } else {
                                session.tab.browse(id, $0)
                            }
                        }
                    }
                }
                Spacer()
            }
            Bar(session: $session, filter: $filter, id: id)
                .frame(height: 1)
        }
    }
    
    private var items: [Item] {
        recent
    }
    
    private var recent: [Item] {
        filter.isEmpty
            ? .init(session
                        .archive
                        .browse
                        .prefix(5)
                        .map(\.page)
                        .map(Item.init(page:)))
            : .init(Set(session
                            .archive
                            .browse
                            .map(\.page)
                            .filter {
                                $0.title.localizedCaseInsensitiveContains(filter)
                                    || $0.string.localizedCaseInsensitiveContains(filter)
                            }
                            .map(Item.init(page:)))
                            .sorted()
                            .prefix(5))
    }
}
