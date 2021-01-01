import SwiftUI

extension Control {
    struct Style<Content>: ButtonStyle where Content : View {
        let state: Control.State
        let current: (Control.State) -> Content
        
        func makeBody(configuration: Configuration) -> some View {
            current(state != .disabled && configuration.isPressed ? .selected : state)
        }
    }
}
