import Foundation

extension Session {
    enum Section {
        case
        tabs,
        tab(UUID),
        search(UUID)
        
        var search: Self {
            switch self {
            case let .tab(id), let .search(id):
                return .search(id)
            default:
                return .tabs
            }
        }
        
        var tab: Self {
            switch self {
            case let .tab(id), let .search(id):
                return .tab(id)
            default:
                return .tabs
            }
        }
    }
}
