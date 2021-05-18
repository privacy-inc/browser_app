import Foundation

extension Session {
    enum Modal: Identifiable {
        var id: UUID {
            switch self {
            case let .bookmarks(id):
                return id
            case let .history(id):
                return id
            }
        }
        
        case
        bookmarks(UUID),
        history(UUID)
    }
}
