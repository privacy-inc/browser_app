import SwiftUI

struct Searchbar: View {
    @Binding var session: Session
    @State private var stats = false
    @State private var settings = false
    @State private var detail = false
    
    var body: some View {
        if session.page == nil {
            Control.Circle(image: "eyeglasses") {
                stats = true
            }
            .sheet(isPresented: $stats) {
                Stats(session: $session)
            }
        } else {
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
                        if session.error == nil {
                            if session.backwards {
                                session.previous.send()
                            } else {
                                session.page = nil
                            }
                        } else {
                            session.unerror.send()
                        }
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
                        session.text.send(session.page!.url.absoluteString)
                        session.type.send()
                    } label: {
                        Text("Edit")
                        Image(systemName: "pencil")
                    }
                    
                    Button {
                        UIPasteboard.general.string = session.page!.url.absoluteString
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
        if session.page == nil {
            Control.Circle(image: "slider.horizontal.3") {
                settings = true
            }
            .sheet(isPresented: $settings) {
                Settings(session: $session)
            }
        } else {
            Control.Circle(image: "xmark") {
                session.page = nil
            }
        }
    }
}
