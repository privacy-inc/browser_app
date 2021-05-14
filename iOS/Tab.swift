import SwiftUI

struct Tab: View {
    @Binding var session: Session
    let id: UUID
    
    var body: some View {
        VStack(spacing: 0) {
            switch session.tab.state(id) {
            case .new:
                New(session: $session)
            case .history:
                Web(session: $session, id: id)
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
            case let .error(history, error):
                Circle()
            }
            Rectangle()
                .fill(Color(.secondarySystemFill))
                .frame(height: 1)
            Bar(session: $session, id: id, snapshot: snapshot)
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
