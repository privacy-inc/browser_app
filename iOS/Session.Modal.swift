import Foundation

extension Session {
    enum Modal: Identifiable, Equatable {
        var id: String {
            "\(self)"
        }
        
        case
        bookmarks(UUID),
        history(UUID),
        info(UUID),
        options(UUID),
        settings,
        trackers,
        activity,
        froob,
        store
    }
}
