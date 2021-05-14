import SwiftUI

struct Tabs: View {
    @Binding var session: Session
    let tabs: Namespace.ID
    let previous: UUID?
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
                GeometryReader { proxy in
                    ScrollView(.horizontal) {
                        ScrollViewReader { scroll in
                            HStack(spacing: 3) {
                                ForEach(0 ..< session.tab.items.count, id: \.self) {
                                    Item(session: $session, id: session.tab.items[$0].id, size: proxy.size)
                                        .id(session.tab.items[$0].id)
                                        .matchedGeometryEffect(id: session.tab.items[$0].id, in: tabs)
                                }
                            }
                            .padding()
                            .onAppear {
                                previous.map {
                                    scroll.scrollTo($0, anchor: .center)
                                }
                            }
                        }
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
