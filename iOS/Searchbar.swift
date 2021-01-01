import SwiftUI

struct Searchbar: View {
    @Binding var session: Session
    @State private var options = false
    
    var body: some View {
        if options {
            HStack {
                Control.Circle(state: .ready, image: "arrow.clockwise") {
                    
                }
                Control.Circle(state: .ready, image: "chevron.left") {
                    
                }
                Control.Circle(state: .ready, image: "chevron.right") {
                    
                }
                Control.Circle(state: .ready, image: "line.horizontal.3") {
                    
                }
            }
        }
        if !session.typing {
            HStack {
                if session.page == nil {
                    Control.Circle(state: .ready, image: "eyeglasses") {
                        
                    }
                } else {
                    Control.Circle(state: options ? .selected : .ready, image: "plus") {
                        options.toggle()
                    }
                }
                Control.Circle(state: .ready, image: "magnifyingglass", action: session.type.send)
                if session.page == nil {
                    Control.Circle(state: .ready, image: "slider.horizontal.3") {
                        
                    }
                } else {
                    Control.Circle(state: .ready, image: "xmark") {
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
