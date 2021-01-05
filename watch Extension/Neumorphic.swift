import SwiftUI

struct Neumorphic: View {
    let image: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("Background"))
                .shadow(color: Color.black.opacity(0.8), radius: 8, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.05), radius: 4, x: -4, y: -4)
                .frame(width: 75, height: 75)
            Image(systemName: image)
                .font(.title2)
        }
    }
}
