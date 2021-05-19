import SwiftUI

protocol Tabber {
    var session: Session { get }
    var id: UUID { get }
}

extension Tabber {
    var browse: Int? {
        session.tab.state(id).browse
    }
}
