import SwiftUI

extension Search {
    struct Bar: UIViewRepresentable {
        @Binding var session: Session
        @Binding var filter: String
        let id: UUID
        
        func makeCoordinator() -> Coordinator {
            .init(wrapper: self, id: id)
        }
        
        func makeUIView(context: Context) -> Coordinator {
            context.coordinator
        }
        
        func updateUIView(_: Coordinator, context: Context) {
            
        }
        
        func dismiss() {
            withAnimation(.easeInOut(duration: 0.3)) {
                session.section = .tab(id)
            }
        }
    }
}
