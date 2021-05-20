import SwiftUI

struct Tab: View {
    @Binding var session: Session
    let id: UUID
    let namespace: Namespace.ID
    @State var snapshot: UIImage?
    @State private var modal = false
    
    var body: some View {
        if let snapshot = snapshot {
            Image(uiImage: snapshot)
                .offset(y: -7)
                .transition(.asymmetric(insertion: .opacity, removal: .scale(scale: 0.7)))
                .matchedGeometryEffect(id: id, in: namespace, properties: .position, isSource: false)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.snapshot = nil
                    }
                }
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
        shot()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.6)) {
                session.section = .tabs(id)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            snapshot = nil
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
