import SwiftUI

struct Tab: View {
    @Binding var session: Session
    let id: UUID
    let namespace: Namespace.ID
    @State private var snapshot: UIImage?
    @State private var scale = CGFloat(1)
    @State private var find = false
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
                        .fill(Color(.tertiaryLabel))
                        .frame(height: 1)
                    switch session.tabs.state(id) {
                    case .new:
                        New(session: $session, id: id)
                    case let .browse(browse):
                        Web(session: $session, id: id, browse: browse)
                            .edgesIgnoringSafeArea(.horizontal)
                        if find {
                            Find(session: $session, find: $find, id: id)
                                .frame(height: 0)
                        }
                    case let .error(browse, error):
                        Error(session: $session, id: id, browse: browse, error: error)
                    }
                    Loading(percent: session.tabs[progress: id])
                    Bar(session: $session, modal: $modal, id: id, tabs: tabs)
                }
                Modal(session: $session, show: $modal, find: $find, id: id)
                session
                    .toast
                    .map {
                        Toast(session: $session, message: $0)
                    }
            }
            .onReceive(session.newTab) { url in
                tabs()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let id = withAnimation(.easeInOut(duration: 0.4)) {
                        tab.new()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        cloud
                            .navigate(url) { browse, _ in
                                tab.browse(id, browse)
                            }
                        withAnimation(.easeInOut(duration: 0.4)) {
                            session.section = .tab(id)
                        }
                    }
                }
            }
        }
    }
    
    private func tabs() {
        UIApplication.shared.resign()
        switch session.tabs.state(id) {
        case .browse:
            tab.update(id, progress: 1)
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
        tab.update(id, snapshot: snapshot)
    }
}
