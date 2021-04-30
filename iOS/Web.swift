import SwiftUI
import Sleuth

struct Web: UIViewRepresentable {
    @Binding var session: Session
    let id: Int
    
    func makeCoordinator() -> Coordinator {
        .init(view: self)
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator
    }
    
    func updateUIView(_ uiView: Coordinator, context: Context) {
        uiView.load(id)
    }
}
