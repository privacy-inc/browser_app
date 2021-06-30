import Foundation

extension Trackers {
    struct Info: CollectionItemInfo {
        let id: Int
        let title: NSAttributedString
        let counter: NSAttributedString
        let dates: [Date]
    }
}
