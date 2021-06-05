import Foundation

extension Purchases {
    enum Item: String, CaseIterable {
        case
        plus = "incognit.plus"
        
        var image: String {
            switch self {
            case .plus: return "plus"
            }
        }
        
        var title: String {
            switch self {
            case .plus: return NSLocalizedString("Privacy Plus", comment: "")
            }
        }
        
        var subtitle: String {
            switch self {
            case .plus: return NSLocalizedString("Support Privacy", comment: "")
            }
        }
    }
}
