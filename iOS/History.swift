import SwiftUI

struct History: View {
    @Binding var session: Session
    
    var body: some View {
//        ScrollView {
            GeometryReader {
                Horizontal(session: $session, lines: min(.init($0.size.width / 150), session.pages.count))
            }
    }
}
