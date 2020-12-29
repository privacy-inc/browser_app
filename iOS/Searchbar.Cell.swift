import SwiftUI

extension Searchbar {
    struct Cell: UIViewRepresentable {
        @Binding var session: Session
        
        func makeCoordinator() -> Coordinator {
            .init(view: self)
        }
        
        func makeUIView(context: Context) -> UISearchBar {
            context.coordinator
        }
        
        func updateUIView(_ uiView: UISearchBar, context: Context) { }
    }
}
