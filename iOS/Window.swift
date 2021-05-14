import SwiftUI

struct Window: View {
    @Binding var session: Session
    @Namespace private var tabs
    
    var body: some View {
        switch session.section {
        case let .tabs(previous):
            Tabs(session: $session, tabs: tabs, previous: previous)
        case let .tab(id):
            Tab(session: $session, id: id)
                .matchedGeometryEffect(id: id, in: tabs)
        case let .search(id):
            Search(session: $session, id: id)
        }
    }
}
