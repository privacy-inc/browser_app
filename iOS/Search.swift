import SwiftUI

struct Search: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Bookmarks")
                
                Text("Recent")
                    .padding(.top)
                Spacer()
            }
            Bar(session: $session)
        }
    }
}
