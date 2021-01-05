import SwiftUI

struct Neumorphic: View {
    let image: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("WidgetBackground"))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 8, y: 8)
                .shadow(color: Color.white, radius: 4, x: -4, y: -4)
                .frame(width: 60, height: 60)
            Image(systemName: image)
                .font(Font.title3)
                .foregroundColor(.black)
        }
    }
}
