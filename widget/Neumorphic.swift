import SwiftUI

struct Neumorphic: View {
    let image: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.04), radius: 5, x: -4, y: -4)
                .frame(width: 54, height: 54)
            Image(systemName: image)
                .font(Font.title3)
        }
    }
}
