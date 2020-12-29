import SwiftUI

extension Control {
    struct Style<Content>: ButtonStyle where Content : View {
        let current: (Bool) -> Content
        
        func makeBody(configuration: Configuration) -> some View {
            current(configuration.isPressed)
        }
    }
}
