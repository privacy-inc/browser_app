import SwiftUI

struct Tab: View {
    @Binding var session: Session
    let id: UUID
    let namespace: Namespace.ID
    @State private var snapshot: UIImage?
    @State private var scale = CGFloat(1)
    @State private var modal = false
    
    var body: some View {
        if let snapshot = snapshot {
            Image(uiImage: snapshot)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .scaleEffect(scale)
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
                .matchedGeometryEffect(id: id, in: namespace, properties: .position, isSource: true)
        } else {
            ZStack {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color(.secondarySystemFill))
                        .frame(height: 1)
                    switch session.tab.state(id) {
                    case .new:
                        New(session: $session, id: id)
                    case let .browse(browse):
                        Web(session: $session, id: id, browse: browse, tabs: tabs)
                            .edgesIgnoringSafeArea(.horizontal)
                    case let .error:
                        Circle()
                    }
                    Indicator(percent: session.tab[progress: id])
                        .stroke(Color.accentColor, lineWidth: 2)
                        .frame(height: 2)
                        .animation(.spring(blendDuration: 0.4))
                        .edgesIgnoringSafeArea(.horizontal)
                    Rectangle()
                        .fill(Color(.secondarySystemFill))
                        .frame(height: 1)
                    Bar(session: $session, modal: $modal, id: id, tabs: tabs)
                }
                Modal(session: $session, show: $modal, id: id)
                session
                    .toast
                    .map {
                        Toast(session: $session, message: $0)
                    }
            }
        }
    }
    
    private func tabs() {
        switch session.tab.state(id) {
        case .browse:
            session.tab[progress: id] = 1
        default:
            break
        }
        shot()

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            withAnimation(.spring(blendDuration: 0.4)) {
                scale = 0.6
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.2)) {
                session.section = .tabs(id)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.snapshot = nil
        }
    }
    
    private func shot() {
        guard let controller = UIApplication.shared.root else { return }
        snapshot = UIGraphicsImageRenderer(size: controller.view.frame.size)
            .image { _ in
                controller.view!.drawHierarchy(in: controller.view.frame, afterScreenUpdates: false)
            }
        session.tab[snapshot: id] = snapshot
    }
}
