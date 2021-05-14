import Foundation

extension Session {
    enum Section {
        case
        tabs(UUID?),
        tab(UUID),
        search(UUID)
    }
}
