import SwiftUI

struct Window: View {
    @Binding var session: Session
    @Namespace private var namespace
    
    var body: some View {
        switch session.section {
        case let .tabs(previous):
            Tabs(session: $session, namespace: namespace, ids: session.tab.ids, previous: previous)
                .transition(.identity)
        case let .tab(id):
            Tab(session: $session, id: id, namespace: namespace)
                .transition(.opacity)
        case let .search(id):
            Search(session: $session, id: id)
                .transition(.opacity)
        }
    }
}
