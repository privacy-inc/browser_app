import SwiftUI

extension Tabs {
    struct Bar: View {
        @Binding var session: Session
        
        var body: some View {
            HStack(spacing: 0) {
                Control(image: "xmark") {
                    
                }
                Control(image: "chart.bar.xaxis") {
                    
                }
                Control(image: "plus") {
                    withAnimation(.spring(blendDuration: 0.6)) {
                        session.section = .tab(session.tab.new())
                    }
                }
                Control(image: "shield.lefthalf.fill") {
                    
                }
                Control(image: "slider.horizontal.3") {
                    
                }
            }
            .padding(.horizontal)
            .frame(height: 34)
            .padding(.vertical, 10)
        }
    }
}
