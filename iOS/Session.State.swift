import UIKit

extension Session {
    struct State {
        static let new = State(progress: 0, loading: false, forward: false, back: false, image: nil, web: nil)
        
        var progress: Double
        var loading: Bool
        var forward: Bool
        var back: Bool
        var image: UIImage?
        var web: Web.Coordinator?
    }
}
