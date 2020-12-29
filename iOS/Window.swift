import SwiftUI

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
