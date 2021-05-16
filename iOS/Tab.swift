import SwiftUI

struct Tab: View {
    @Binding var session: Session
    let id: UUID
    @State private var modal = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch session.tab.state(id) {
                case .new:
                    New(session: $session, id: id)
                case .browse:
                    Web(session: $session, id: id)
                        .edgesIgnoringSafeArea([.top, .leading, .trailing])
                case let .error:
                    Circle()
                }
                Rectangle()
                    .fill(Color(.systemFill))
                    .frame(height: 1)
                Bar(session: $session, modal: $modal, id: id, snapshot: snapshot)
            }
            Modal(session: $session, show: $modal, id: id)
            session
                .toast
                .map {
                    Toast(session: $session, message: $0)
                }
        }
    }
    
    private func snapshot() {
        let controller = UIHostingController(rootView: self)
        controller.view!.bounds = .init(origin: .zero, size: UIScreen.main.bounds.size)
        session[id].image = UIGraphicsImageRenderer(size: UIScreen.main.bounds.size)
            .image { _ in
                controller.view!.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
            }
    }
}
