import SwiftUI

struct Searchbar: View {
    @Binding var session: Session
    
    var body: some View {
        VStack {
            Spacer()
            Field(session: $session)
            HStack {
                Control.Circle(image: "chart.pie") {
                    
                }
                Control.Circle(image: "magnifyingglass", action: session.type.send)
                Control.Circle(image: "slider.horizontal.3") {
                    
                }
            }
            .opacity(session.typing ? 0 : 1)
            .animation(.easeInOut(duration: 0.35))
        }
    }
}
