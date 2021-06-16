import SwiftUI

extension Tab {
    struct New: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            ZStack {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea(.horizontal)
                GeometryReader { proxy in
                    ScrollView {
                        Button {
                            session.modal = .bookmarks(id)
                        } label: {
                            ZStack {
                                Capsule()
                                    .fill(Color.accentColor)
                                Label("Bookmarks", systemImage: "list.bullet")
                                    .font(.callout)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 7)
                                    .padding(.horizontal)
                            }
                            .contentShape(Rectangle())
                            .fixedSize()
                        }
                        .padding(.top)
                        Bookmarks(session: $session, id: id)
                        Button {
                            session.modal = .history(id)
                        } label: {
                            ZStack {
                                Capsule()
                                    .fill(Color.accentColor)
                                Label("Recent", systemImage: "list.bullet")
                                    .font(.callout)
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
                    }
                }
            }
        }
    }
}
