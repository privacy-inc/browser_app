import SwiftUI

extension Tab {
    struct New: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            ZStack {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea([.leading, .trailing, .top])
                GeometryReader { proxy in
                    ScrollView(showsIndicators: false) {
                        Button {
                            session.modal = .bookmarks(id)
                        } label: {
                            ZStack {
                                Capsule()
                                    .fill(Color.accentColor)
                                Label("BOOKMARKS", systemImage: "list.bullet")
                                    .font(.footnote.bold())
                                    .foregroundColor(.white)
                                    .padding(.vertical, 7)
                                    .padding(.horizontal)
                            }
                            .contentShape(Rectangle())
                            .fixedSize()
                        }
                        .padding(.top, 25)
                        .padding(.bottom, 10)
                        Bookmarks(session: $session, id: id)
                        Button {
                            session.modal = .history(id)
                        } label: {
                            ZStack {
                                Capsule()
                                    .fill(Color.accentColor)
                                Label("RECENT", systemImage: "list.bullet")
                                    .font(.footnote.bold())
                                    .foregroundColor(.white)
                                    .padding(.vertical, 7)
                                    .padding(.horizontal)
                            }
                            .contentShape(Rectangle())
                            .fixedSize()
                        }
                        .padding(.top, 50)
                        .padding(.bottom)
                        History(session: $session, id: id, metrics: .init(size: proxy.size))
                            .padding(.bottom, 60)
                    }
                }
            }
        }
    }
}
