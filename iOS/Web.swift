import SwiftUI
import Archivable

struct Web: UIViewRepresentable {
    @Binding var session: Session
    let id: UUID
    let browse: Int
    let tabs: () -> Void
    
    func makeCoordinator() -> Coordinator {
        let coordinator = session.tab[web: id] as? Coordinator ?? .init(session: session, id: id, browse: browse)
        coordinator.wrapper = self
        if session.tab[web: id] == nil {
            session.tab[web: id] = coordinator
            session
                .archive
                .page(browse)
                .url
                .map(coordinator.load)
        }
        return coordinator
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator
    }
    
    func updateUIView(_: Coordinator, context: Context) { }
    
    func open(_ url: URL) {
        tabs()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let id = withAnimation(.spring(blendDuration: 0.5)) {
                session.tab.new()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                Cloud.shared.browse(url.absoluteString, id: nil) { browse, _ in
                    session.tab.browse(id, browse)
                }
                session.section = .tab(id)
            }
        }
    }
    
    static func dismantleUIView(_: Coordinator, coordinator: Coordinator) {
        coordinator.wrapper = nil
    }
}
