import SwiftUI

extension Control {
    struct Circle: View {
        var background = Color.background
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) { }
                .buttonStyle(Style { Shape(image: image, background: background, pressed: $0) })
        }
    }
}
