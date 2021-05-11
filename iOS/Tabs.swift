import SwiftUI

struct Tabs: View {
    @Binding var session: Session
    let tabs: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal) {
                ForEach(0 ..< session.tab.items.count, id: \.self) {
                    Item(session: $session, id: session.tab.items[$0].id)
                        .matchedGeometryEffect(id: session.tab.items[$0].id, in: tabs)
                        .padding()
                }
            }
            Bar(session: $session)
        }
    }
}
