import SwiftUI

extension Tab {
    struct Find: UIViewRepresentable {
        @Binding var session: Session
        @Binding var find: Bool
        let id: UUID
        
        func makeCoordinator() -> Coordinator {
            .init(wrapper: self, id: id)
        }
        
        func makeUIView(context: Context) -> Coordinator {
            context.coordinator
        }
        
        func updateUIView(_: Coordinator, context: Context) {
            
        }
    }
}
