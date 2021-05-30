import SwiftUI
import Sleuth

struct Search: View {
    @Binding var session: Session
    let id: UUID
    @State private var filter = ""
    @State private var bookmarks = [Filtered]()
    @State private var recent = [Filtered]()
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            Color.accentColor.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                if bookmarks.isEmpty && recent.isEmpty {
                    Image("blank")
                        .padding(.top, 100)
                        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
                }
                if !bookmarks.isEmpty {
                    Text("Bookmarks")
                        .font(.footnote.bold())
                        .foregroundColor(.accentColor)
                        .padding([.top, .leading])
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    ForEach(bookmarks, id: \.self, content: cell)
                }
                if !recent.isEmpty {
                    Text("Recent")
                        .font(.footnote.bold())
                        .foregroundColor(.accentColor)
                        .padding(.leading)
                        .padding(.top, 30)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    ForEach(recent, id: \.self, content: cell)
                }
            }
            .animation(.spring(blendDuration: 0.2))
            Bar(session: $session, filter: $filter, id: id)
                .frame(height: 0)
        }
        .onAppear(perform: update)
        .onChange(of: filter) { _ in
            update()
        }
    }
    
    private func update() {
        bookmarks = session
            .archive
            .bookmarks
            .filter(filter)
        recent = session
            .archive
            .browse
            .filter(filter)
    }
    
    private func cell(_ filtered: Filtered) -> Cell {
        .init(filtered: filtered) {
            let browse = session.tab[state: id].browse
            cloud
                .browse(filtered.url, id: browse) {
                    UIApplication.shared.resign()
                    session.section = .tab(id)
                    tabber.browse(id, $0)
                    if browse == $0 {
                        session.load.send((id: id, access: $1))
                    }
                }
        }
    }
}
