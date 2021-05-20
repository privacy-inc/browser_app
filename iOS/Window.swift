import SwiftUI

struct Window: View {
    @Binding var session: Session
    @Namespace private var namespace
    
    var body: some View {
        switch session.section {
        case let .tabs(previous):
            Tabs(session: $session, namespace: namespace, previous: previous)
        case let .tab(id):
            Tab(session: $session, id: id, namespace: namespace, snapshot: session.tab[snapshot: id] as? UIImage)
                .ignoresSafeArea(.keyboard)
        case let .search(id):
            Search(session: $session, id: id)
        }
    }
}
