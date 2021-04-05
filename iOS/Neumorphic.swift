import SwiftUI

struct Neumorphic: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(UIApplication.dark ? 0.5 : 0.05), radius: 5, x: 5, y: 5)
            .shadow(color: Color.white.opacity(UIApplication.dark ? 0.04 : 0.6), radius: 2, x: -2, y: -2)
    }
}
