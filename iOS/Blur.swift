import SwiftUI

struct Blur: UIViewRepresentable {
    let effect: UIVisualEffect
    
    func makeCoordinator() -> Coordinator {
        .init(effect: effect)
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator
    }
    
    func updateUIView(_: Coordinator, context: Context) {
        
    }
}
