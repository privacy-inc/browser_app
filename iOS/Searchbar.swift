import SwiftUI

struct Searchbar: View {
    @Binding var session: Session
    @State private var stats = false
    @State private var settings = false
    @State private var detail = false
    
    var body: some View {
        switch session.section {
        case .history:
            Control.Circle(image: "eyeglasses") {
                stats = true
            }
            .sheet(isPresented: $stats) {
                Stats(session: $session)
            }
        case .browse:
            Menu {
                Button {
                    detail = true
                } label: {
                    Text("More")
                    Image(systemName: "ellipsis")
                }
                
                Button(action: session.stop.send) {
                    Text("Stop")
                    Image(systemName: "xmark")
                }
                .disabled(!session.loading)
                
                Button(action: session.reload.send) {
                    Text("Reload")
                    Image(systemName: "arrow.clockwise")
                }
                
                Menu {
                    Button {
                        session.previous.send()
                    } label: {
                        Text("Back")
                        Image(systemName: "chevron.left")
                    }
                    
                    Button(action: session.next.send) {
                        Text("Forward")
                        Image(systemName: "chevron.right")
                    }
                    .disabled(!session.forwards)
                } label: {
                    Text("Move")
                    Image(systemName: "arrow.left.arrow.right")
                }
                
                Menu {
                    Button {
                        session
                            .entry
                            .map(\.url)
                            .map(session.text.send)
                        session.type.send()
                    } label: {
                        Text("Edit")
                        Image(systemName: "pencil")
                    }
                    
                    Button {
                        session
                            .entry
                            .map {
                                UIPasteboard.general.string = $0.url
                            }
                    } label: {
                        Text("Copy")
                        Image(systemName: "doc.on.doc")
                    }
                } label: {
                    Text("URL")
                    Image(systemName: "link")
                }
            } label: {
                Control.Circle.Shape(image: "plus", background: .background, pressed: false)
            }
            .fixedSize()
            .ignoresSafeArea(.all)
            .sheet(isPresented: $detail) {
                Detail(session: $session)
            }
        }
        
        Control.Circle(image: "magnifyingglass", action: session.type.send)
        
        switch session.section {
        case .history:
            Control.Circle(image: "slider.horizontal.3") {
                settings = true
            }
            .sheet(isPresented: $settings) {
                Settings(session: $session)
            }
        case .browse:
            Control.Circle(image: "xmark") {
                session.section = .history
            }
        }
    }
}
