import SwiftUI

extension Tab {
    struct New: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            GeometryReader { proxy in
                ScrollView {
                    HStack {
                        Text("Bookmarks")
                            .font(.footnote.bold())
                            .foregroundColor(.accentColor)
                            .padding(.leading)
                        Spacer()
                        Button {
                            session.modal = .bookmarks(id)
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.title3)
                                .frame(width: 65, height: 30)
                                .contentShape(Rectangle())
                        }
                    }
                    .padding(.top)
                    Bookmarks(session: $session, id: id)
                    HStack {
                        Text("Recent")
                            .font(.footnote.bold())
                            .foregroundColor(.accentColor)
                            .padding(.leading)
                        Spacer()
                        Button {
                            session.modal = .history(id)
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.title3)
                                .frame(width: 65, height: 30)
                                .contentShape(Rectangle())
                        }
                    }
                    .padding(.top, 30)
                    History(session: $session, id: id, metrics: .init(size: proxy.size))
                }
            }
        }
    }
}
