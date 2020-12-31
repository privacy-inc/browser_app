import SwiftUI

struct Searchbar: View {
    @Binding var session: Session
    
    var body: some View {
        if !session.typing {
            HStack {
                if session.page == nil {
                    Control.Circle(image: "eyeglasses") {
                        
                    }
                } else {
                    Control.Circle(image: "plus") {
                        
                    }
                }
                Control.Circle(image: "magnifyingglass", action: session.type.send)
                if session.page == nil {
                    Control.Circle(image: "slider.horizontal.3") {
                        
                    }
                } else {
                    Control.Circle(image: "xmark") {
                        session.page = nil
                    }
                }
            }
            .animation(.easeInOut(duration: 0.35))
        }
        Field(session: $session)
            .frame(height: 0)
    }
}
