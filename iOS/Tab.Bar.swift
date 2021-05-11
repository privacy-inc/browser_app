import SwiftUI

extension Tab {
    struct Bar: View {
        @Binding var session: Session
        
        var body: some View {
            ZStack {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea([.bottom, .leading, .trailing])
                HStack(spacing: 0) {
                    Search(session: $session)
                }
                .frame(height: 32)
                .padding(.vertical, 10)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
