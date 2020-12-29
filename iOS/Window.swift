import SwiftUI

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            Searchbar(session: $session)
        }
    }
}
