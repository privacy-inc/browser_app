import SwiftUI

extension Tab {
    struct New: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            GeometryReader { proxy in
                ScrollView {
                    Bookmarks(session: $session, id: id)
                    History(session: $session, id: id, metrics: .init(size: proxy.size))
                }
            }
        }
    }
}
