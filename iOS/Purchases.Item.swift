import Foundation

extension Purchases {
    enum Item: String, CaseIterable, Codable {
        case
        plus = "walkhero.plus"
        
        var image: String {
            switch self {
            case .plus: return "plus"
            }
        }
        
        var title: String {
            switch self {
            case .plus: return NSLocalizedString("WalkHero+", comment: "")
            }
        }
        
        var subtitle: String {
            switch self {
            case .plus: return NSLocalizedString("""
Support the development of this app.

Your contribution allows a very small indie team to update and maintain WalkHero.
""", comment: "")
            }
        }
    }
}
