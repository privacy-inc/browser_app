import Foundation
import Sleuth

extension History.Map {
    struct Item: Hashable {
        let page: Page
        let frame: CGRect
        
        func hash(into: inout Hasher) {
            into.combine(page)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.page == rhs.page
        }
    }
}
