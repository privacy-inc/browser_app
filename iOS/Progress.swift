import SwiftUI

struct Progress: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            Bar(progress: 1)
                .fill(Color(.systemBackground))
            if session.page != nil {
                Bar(progress: .init(session.progress))
                    .fill(Color.accentColor)
                    .animation(.easeInOut(duration: 0.3))
            }
        }
        .frame(height: 3)
    }
}
