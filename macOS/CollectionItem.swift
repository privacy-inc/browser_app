import AppKit

struct CollectionItem<I>: Hashable where I : CollectionItemInfo {
    let info: I
    let rect: CGRect
}
