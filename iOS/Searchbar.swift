import SwiftUI

struct Searchbar: View {
    @Binding var session: Session
    @State private var global = false
    
    var body: some View {
        if !session.typing {
            HStack {
                if global {
                    Control.Circle(image: "eyeglasses") {
                        
                    }
                } else {
                    Control.Circle(image: "plus") {
                        
                    }
                }
                Control.Circle(image: "magnifyingglass", action: session.type.send)
                if session.browser.page.value == nil {
                    Control.Circle(image: "slider.horizontal.3") {
                        
                    }
                } else {
                    Control.Circle(image: "xmark") {
                        session.browser.page.value = nil
                    }
                }
            }
            .animation(.easeInOut(duration: 0.35))
        }
        Field(session: $session)
            .frame(height: 0)
            .onReceive(session.browser.page) { page in
                guard (page == nil && !global) || (page != nil && global) else { return }
                withAnimation(.easeInOut(duration: 0.35)) {
                    global = page == nil
                }
            }
    }
}
