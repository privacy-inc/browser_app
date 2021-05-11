import SwiftUI

struct Tab: View {
    @Binding var session: Session
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Some title")
            ScrollView {
                VStack(spacing: 0) {
                    
                }
            }
            Bar(session: $session)
        }
    }
}
