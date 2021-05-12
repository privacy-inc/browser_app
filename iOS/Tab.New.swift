import SwiftUI

extension Tab {
    struct New: View {
        @Binding var session: Session
        
        var body: some View {
            ScrollView {
                VStack(spacing: 0) {
                    Text("Hello world!")
                }
            }
        }
    }
}
