import SwiftUI

struct Web: UIViewRepresentable {
    @Binding var session: Session
    let id: UUID
    
    func makeCoordinator() -> Coordinator {
        let coordinator = session[id].web ?? .init(wrapper: self)
        if session[id].web == nil {
            session[id].web = coordinator
        }
        print(session[id])
        return coordinator
    }
    
    func makeUIView(context: Context) -> Coordinator {
        
        print("b")
        return context.coordinator
    }
    
    func updateUIView(_: Coordinator, context: Context) {
        print("a")
    }
}
