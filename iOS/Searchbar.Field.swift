import SwiftUI

extension Searchbar {
    struct Field: View {
        @Binding var session: Session
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 90)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.background)
                    .frame(height: 44)
                    .padding(.horizontal, 20)
                    .shadow(color: Color.black.opacity(0.5), radius: 6)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.primary.opacity(0.05))
                    .frame(height: 44)
                    .padding(.horizontal, 20)
                Cell(session: $session)
                    .padding(.horizontal, 24)
                    .padding(.trailing)
            }
        }
    }
}
