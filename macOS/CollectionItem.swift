import AppKit

struct CollectionItem: Hashable {
    let info: CollectionItemInfo
    let rect: CGRect
    
    func hash(into: inout Hasher) {
        into.combine(info)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.info == rhs.info
    }
}
