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
                Circle()
                    .fill(background)
                    .modifier(Neumorphic())
                    .frame(width: 42, height: 42)
                Image(systemName: image)
                    .font(.callout)
                    .foregroundColor(pressed ? .init(.tertiaryLabel) : .primary)
            }
            .frame(width: Metrics.search.circle, height: Metrics.search.circle)
        }
    }
}
