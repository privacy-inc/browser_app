import SwiftUI

extension Control.Circle {
    struct Shape: View {
        let image: String
        let background: Color
        let pressed: Bool
        
        var body: some View {
            ZStack {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 80, height: 80)
                if pressed {
                    Circle()
                        .fill(UIApplication.dark ? Color.black : .white)
                        .frame(width: 44, height: 44)
                } else {
                    Circle()
                        .fill(background)
                        .modifier(Neumorphic())
                        .frame(width: 50, height: 50)
                }
                Image(systemName: image)
                    .foregroundColor(pressed ? .init(.tertiaryLabel) : .primary)
            }
            .contentShape(Circle())
        }
    }
}
