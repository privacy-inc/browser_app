import Foundation

extension Session {
    enum Section {
        case
        tabs,
        tab(UUID),
        search(UUID)
    }
}
