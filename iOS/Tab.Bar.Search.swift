import SwiftUI

extension Tab.Bar {
    struct Search: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.tertiarySystemFill))
                Image(systemName: "magnifyingglass")
            }
            .frame(width: 60)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    session.section = .search(id)
                }
            }
        }
    }
}
