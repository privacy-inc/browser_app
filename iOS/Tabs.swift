import SwiftUI

struct Tabs: View {
    @Binding var session: Session
    let namespace: Namespace.ID
    let ids: [UUID]
    let previous: UUID?
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
                GeometryReader { proxy in
                    ScrollView(.horizontal) {
                        ScrollViewReader { scroll in
                            HStack(spacing: 5) {
                                ForEach(0 ..< ids.count, id: \.self) {
                                    Item(session: $session, id: ids[$0], namespace: namespace, size: proxy.size)
                                        .id(ids[$0])
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
                session
                    .toast
                    .map {
                        Toast(session: $session, message: $0)
                    }
            }
            Rectangle()
                .fill(Color(.systemFill))
                .frame(height: 1)
            Bar(session: $session)
        }
    }
}
