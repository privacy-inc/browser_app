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
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                        Spacer()
                        Button {
                            session.modal = .bookmarks
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.title3)
                                .frame(width: 65, height: 40)
                                .contentShape(Rectangle())
                        }
                    }
                    .padding(.top)
                    Bookmarks(session: $session, id: id)
                    HStack {
                        Text("Recent")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                        Spacer()
                        Button {
                            session.modal = .recent
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.title3)
                                .frame(width: 65, height: 40)
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
