import Foundation

extension History.Map {
    struct Item: Hashable {
        let page: Page
        let frame: CGRect
        
        func hash(into: inout Hasher) {
            into.combine(page.page)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.page.page == rhs.page.page
        }
    }
}
