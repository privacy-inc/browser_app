import SwiftUI

struct Neumorphic: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(UIApplication.dark ? 0.5 : 0.05), radius: 8, x: 8, y: 8)
            .shadow(color: Color.white.opacity(UIApplication.dark ? 0.04 : 0.6), radius: 3, x: -3, y: -3)
    }
}
