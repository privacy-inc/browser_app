import SwiftUI
import Sleuth

struct Search: View {
    @Binding var session: Session
    let id: UUID
    @State private var filter = ""
    @State private var bookmarks = [Filtered]()
    @State private var history = [Filtered]()
    
    var body: some View {
        ZStack {
            Color
                .black
                .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
            Color(white: 0.2, opacity: 1)
                .padding(.bottom, 1)
                .edgesIgnoringSafeArea([.leading, .trailing, .top])
            if bookmarks.isEmpty && history.isEmpty {
                Image("blank")
                    .padding(.top, 100)
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
            } else {
                ScrollView(showsIndicators: false) {
                    Spacer()
                        .frame(height: 20)
                    if !bookmarks.isEmpty {
                        Autocomplete(session: $session, id: id, title: "BOOKMARKS", items: bookmarks)
                    }
                    if !history.isEmpty {
                        Autocomplete(session: $session, id: id, title: "HISTORY", items: history)
                    }
                    Spacer()
                        .frame(height: 20)
                }
                .animation(.spring(blendDuration: 0.2))
            }
            Bar(session: $session, filter: $filter, id: id)
                .frame(height: 0)
            session
                .toast
                .map {
                    Toast(session: $session, message: $0)
                }
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
        history = session
            .archive
            .browse
            .filter(filter)
    }
}
