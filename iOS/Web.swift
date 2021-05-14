import SwiftUI

struct Web: UIViewRepresentable, Tabber {
    @Binding var session: Session
    let id: UUID
    
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
}
