import SwiftUI

struct Tabs: View {
    @Binding var session: Session
    let tabs: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
                GeometryReader { proxy in
                    ScrollView(.horizontal) {
                        HStack(spacing: 3) {
                            ForEach(0 ..< session.tab.items.count, id: \.self) {
                                Item(session: $session, id: session.tab.items[$0].id, size: proxy.size)
                                    .matchedGeometryEffect(id: session.tab.items[$0].id, in: tabs)
                            }
                        }
                        .padding()
                    }
                }
            }
            Rectangle()
                .fill(Color(.systemFill))
                .frame(height: 1)
            Bar(session: $session)
        }
    }
}
