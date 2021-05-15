import SwiftUI

extension Tab {
    struct New: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            GeometryReader { proxy in
                ScrollView {
                    Text("Bookmarks")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding([.leading, .top])
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    Bookmarks(session: $session, id: id)
                    Text("Recent")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding([.leading, .top])
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    History(session: $session, id: id, metrics: .init(size: proxy.size))
                }
            }
        }
    }
}
