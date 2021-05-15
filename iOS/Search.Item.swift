import Foundation

extension Search {
    struct Item: Hashable, Comparable {
        let title: String
        let url: String
        
        static func < (lhs: Search.Item, rhs: Search.Item) -> Bool {
            lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
        }
    }
}
