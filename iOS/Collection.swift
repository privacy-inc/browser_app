import SwiftUI

struct Collection: View {
    @Binding var session: Session
    let id: UUID
    let modal: Session.Modal
    
    var body: some View {
        Popup(title: title, leading: { }) {
            List {
                switch modal {
                case .bookmarks:
                    Bookmarks(session: $session, id: id, bookmarks: session.archive.bookmarks)
                case .history:
                    History(session: $session, id: id, browse: session.archive.browse)
                default:
                    EmptyView()
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    private var title: String {
        switch modal {
        case .bookmarks:
            return "Bookmarks"
        case .history:
            return "History"
        default:
            return ""
        }
    }
}
