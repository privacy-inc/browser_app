import SwiftUI

extension Tabs {
    struct Bar: View {
        @Binding var session: Session
        @State private var close = false
        
        var body: some View {
            HStack(spacing: 0) {
                Control(image: "xmark") {
                    close = true
                }
                .actionSheet(isPresented: $close) {
                    .init(title: .init("Close all tabs?"),
                          buttons: [
                            .destructive(.init("Close all")) {
                                withAnimation(.spring(blendDuration: 0.4)) {
                                    session.section = .search(session.tab.closeAll())
                                }
                            },
                            .cancel()])
                }
                
                Control(image: "chart.bar.xaxis") {
                    
                }
                
                Control(image: "plus") {
                    withAnimation(.spring(blendDuration: 0.4)) {
                        session.section = .search(session.tab.new())
                    }
                }
                
                Control(image: "shield.lefthalf.fill") {
                    
                }
                
                Control(image: "slider.horizontal.3") {
                    session.modal = .settings
                }
            }
            .padding(.horizontal)
            .frame(height: 34)
            .padding(.vertical, 10)
        }
    }
}
