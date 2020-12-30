import SwiftUI

struct Searchbar: View {
    @Binding var session: Session
    
    var body: some View {
        if !session.typing {
            HStack {
                Control.Circle(image: "eyeglasses") {
                    
                }
                .padding(.trailing, 5)
                Control.Circle(image: "magnifyingglass", action: session.type.send)
                    .padding(.horizontal, 5)
                Control.Circle(image: "slider.horizontal.3") {
                    
                }
                .padding(.leading, 5)
            }
            .animation(.easeInOut(duration: 0.35))
        }
        Field(session: $session)
            .frame(height: 0)
    }
}
