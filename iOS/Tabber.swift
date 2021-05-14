import Foundation

protocol Tabber {
    var session: Session { get }
    var id: UUID { get }
}

extension Tabber {
    var history: Int? {
        switch session.tab.state(id) {
        case .new:
            return nil
        case let .history(history), let .error(history, _):
            return history
        }
    }
}
