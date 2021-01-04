import SwiftUI

struct Neumorphic: View {
    let image: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("AccentColor"))
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.08), radius: 4, x: -4, y: -4)
                .frame(width: 70, height: 70)
            Image(systemName: image)
                .font(Font.title2.bold())
                .foregroundColor(.black)
        }
    }
}
