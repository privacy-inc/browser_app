import SwiftUI

extension Tab.Bar {
    struct Search: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    session.section = .search(id)
                    session.search.send()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.tertiarySystemFill))
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.primary)
                }
                .frame(width: 60)
                .contentShape(Rectangle())
            }
        }
    }
}
