import SwiftUI

extension Tab.Bar {
    struct Search: View {
        @Binding var session: Session
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.systemFill))
                Image(systemName: "magnifyingglass")
            }
            .frame(width: 140)
        }
    }
}
