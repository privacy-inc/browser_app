import Foundation

extension Trackers {
    struct Info: CollectionItemInfo {
        let id: Int
        let text: NSAttributedString
        let dates: [Date]
    }
}
