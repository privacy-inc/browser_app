import SwiftUI

protocol Tabber {
    var session: Session { get }
    var id: UUID { get }
}

extension Tabber {
    var browse: Int? {
        switch session.tab.state(id) {
        case .new:
            return nil
        case let .browse(id), let .error(id, _):
            return id
        }
    }
}
