import Foundation

extension History.Map {
    struct Item: Hashable {
        let page: Page
        let frame: CGRect
        
        func hash(into: inout Hasher) {
            into.combine(page.entry)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.page.entry == rhs.page.entry
        }
    }
}
