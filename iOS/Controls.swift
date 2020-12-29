import SwiftUI

struct Controls: View {
    @Binding var session: Session
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Control.Circle(image: "chart.pie") {
                    
                }
                Control.Circle(image: "magnifyingglass") {
                    
                }
                Control.Circle(image: "slider.horizontal.3") {
                    
                }
            }
        }
    }
}
