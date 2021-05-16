import Foundation
import Sleuth

extension Search {
    struct Item: Hashable, Comparable {
        let title: String
        let url: String
        
        init(page: Page) {
            title = page.title
            url = page.string
        }
        
        static func < (lhs: Search.Item, rhs: Search.Item) -> Bool {
            lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
        }
    }
}
