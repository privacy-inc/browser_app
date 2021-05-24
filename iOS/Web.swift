import SwiftUI
import Archivable

struct Web: UIViewRepresentable {
    @Binding var session: Session
    let id: UUID
    let browse: Int
    let tabs: () -> Void
    
    func makeCoordinator() -> Coordinator {
        session.tab[web: id] as? Coordinator ?? .init(wrapper: self, id: id, browse: browse)
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator.wrapper = self
        if session.tab[web: id] == nil {
            context.coordinator.load(session.archive.page(browse).access)
            session.tab[web: id] = context.coordinator
        }
        return context.coordinator
    }
    
    func updateUIView(_: Coordinator, context: Context) { }
    
    func open(_ url: URL) {
        tabs()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let id = withAnimation(.easeInOut(duration: 0.4)) {
                session.tab.new()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Cloud.shared.navigate(url) { browse, _ in
                    session.tab.browse(id, browse)
                }
                withAnimation(.easeInOut(duration: 0.4)) {
                    session.section = .tab(id)
                }
            }
        }
    }
    
    static func dismantleUIView(_: Coordinator, coordinator: Coordinator) {
        coordinator.wrapper = nil
    }
}
