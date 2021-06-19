import SwiftUI

struct Blur: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeCoordinator() -> UIVisualEffectView {
        .init(effect: UIBlurEffect(style: style))
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        context.coordinator
    }
    
    func updateUIView(_: UIVisualEffectView, context: Context) {
        
    }
}
