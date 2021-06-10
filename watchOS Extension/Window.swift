import SwiftUI

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        TabView {
            Activity(session: $session)
            Trackers(session: $session)
            Forget()
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
