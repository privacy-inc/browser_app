import SwiftUI

struct Neumorphic: View {
    let image: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(white: 0.125))
                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.05), radius: 5, x: -4, y: -4)
                .frame(width: 60, height: 60)
            Image(systemName: image)
                .font(Font.title3)
        }
    }
}
