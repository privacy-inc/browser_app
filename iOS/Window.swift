import SwiftUI

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        switch session.section {
        case .tabs:
            Tabs(session: $session)
        case let .tab(id):
            Tab(session: $session)
        }
    }
}
