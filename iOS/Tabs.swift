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
                VStack(alignment: .leading) {
                    Button(action: closeAll) {
                        Label("CLOSE ALL", systemImage: "xmark")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(height: 28)
                            .contentShape(Rectangle())
                    }
                    .padding([.leading, .top])
                    GeometryReader { proxy in
                        ScrollView(.horizontal) {
                            ScrollViewReader { scroll in
                                HStack(spacing: 5) {
                                    ForEach(0 ..< ids.count, id: \.self) {
                                        Item(session: $session, id: ids[$0], namespace: namespace, size: proxy.size)
                                            .id(ids[$0])
                                    }
                                }
                                .padding([.leading, .trailing, .bottom])
                                .onAppear {
                                    previous.map {
                                        scroll.scrollTo($0, anchor: .center)
                                    }
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
                .fill(Color.accentColor)
                .frame(height: 1)
            Bar(session: $session, closeAll: closeAll)
        }
    }
    
    private func closeAll() {
        session
            .tab
            .ids
            .forEach {
                (session.tab[web: $0] as? Web.Coordinator)?.clear()
            }
        
        withAnimation(.spring(blendDuration: 0.4)) {
            session.section = .search(tabber.closeAll())
        }
    }
}
