import Foundation

extension Trackers {
    struct Info: CollectionItemInfo {
        let id: String
        let text: NSAttributedString
        let dates: [Date]
        let first: Bool
    }
}
