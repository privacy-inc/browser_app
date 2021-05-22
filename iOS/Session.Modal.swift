import Foundation

extension Session {
    enum Modal: Identifiable {
        var id: String {
            "\(self)"
        }
        
        case
        bookmarks(UUID),
        history(UUID),
        info(UUID),
        options(UUID),
        settings,
        trackers
    }
}
