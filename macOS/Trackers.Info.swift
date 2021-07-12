import Foundation

extension Trackers {
    struct Info: CollectionItemInfo {
        let id: Int
        let reference: String
        let text: NSAttributedString
        let dates: [Date]
    }
}
