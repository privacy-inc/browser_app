import SwiftUI

struct Window: View {
    @Binding var session: Session
    @Namespace private var tabs
    
    var body: some View {
        switch session.section {
        case .tabs:
            Tabs(session: $session, tabs: tabs)
        case .search:
            Search(session: $session)
        case let .tab(id):
            Tab(session: $session, id: id)
                .matchedGeometryEffect(id: id, in: tabs)
        }
    }
}
