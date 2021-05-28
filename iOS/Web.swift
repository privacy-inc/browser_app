import SwiftUI

struct Web: UIViewRepresentable {
    @Binding var session: Session
    let id: UUID
    let browse: Int
    let tabs: () -> Void
    
    func makeCoordinator() -> Coordinator {
        session.tabs[web: id] as? Coordinator ?? .init(wrapper: self, id: id, browse: browse)
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator.wrapper = self
        if session.tabs[web: id] == nil {
            context.coordinator.load(session.archive.page(browse).access)
            tab.update(id, web: context.coordinator)
        }
        return context.coordinator
    }
    
    func updateUIView(_: Coordinator, context: Context) { }
    
    func open(_ url: URL) {
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
    
    static func dismantleUIView(_: Coordinator, coordinator: Coordinator) {
        coordinator.wrapper = nil
    }
}
