import SwiftUI
import Archivable

struct Web: UIViewRepresentable, Tabber {
    @Binding var session: Session
    let id: UUID
    let tabs: () -> Void
    
    func makeCoordinator() -> Coordinator {
        let coordinator = session[id].web ?? .init(wrapper: self)
        if session[id].web == nil {
            session[id].web = coordinator
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
                Cloud.shared.browse(url.absoluteString, id: nil) {
                    session.tab.browse(id, $0)
                }
                session.section = .tab(id)
            }
        }
    }
}
