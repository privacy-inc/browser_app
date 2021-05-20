import SwiftUI
import Archivable

struct Web: UIViewRepresentable {
    @Binding var session: Session
    let id: UUID
    let browse: Int
    let tabs: () -> Void
    
    func makeCoordinator() -> Coordinator {
        let coordinator = session.tab[web: id] as? Coordinator ?? .init(wrapper: self, id: id, browse: browse)
        coordinator.wrapper = self
        if session.tab[web: id] == nil {
            coordinator.load(session.archive.page(browse).access)
            session.tab[web: id] = coordinator
        }
        return coordinator
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator
    }
    
    func updateUIView(_: Coordinator, context: Context) { }
    
    func open(_ url: URL) {
        tabs()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            let id = withAnimation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6)) {
                session.tab.new()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Cloud.shared.browse(url.absoluteString, id: nil) { browse, _ in
                    session.tab.browse(id, browse)
                }
                withAnimation(.easeInOut(duration: 0.3)) {
                    session.section = .tab(id)
                }
            }
        }
    }
    
    static func dismantleUIView(_: Coordinator, coordinator: Coordinator) {
        coordinator.wrapper = nil
    }
}
