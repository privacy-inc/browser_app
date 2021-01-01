import SwiftUI

struct Searchbar: View {
    @Binding var session: Session
    @State private var options = false
    @State private var detail = false
    
    var body: some View {
        if !session.typing {
            Spacer()
                .frame(height: 10)
            if options && session.page != nil {
                HStack {
                    Control.Circle(state: .ready, image: "arrow.clockwise", action: session.reload.send)
                    Control.Circle(state: session.backwards ? .ready : .disabled, image: "chevron.left", action: session.previous.send)
                    Control.Circle(state: session.forwards ? .ready : .disabled, image: "chevron.right", action: session.next.send)
                    Control.Circle(state: .ready, image: "line.horizontal.3") {
                        detail = true
                    }
                    .sheet(isPresented: $detail) {
                        Detail(session: $session)
                    }
                }
            }
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
            Spacer()
                .frame(height: 10)
        }
        Field(session: $session)
            .frame(height: 0)
    }
}
