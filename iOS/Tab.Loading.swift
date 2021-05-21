import SwiftUI

extension Tab {
    struct Loading: View {
        let percent: Double
        
        var body: some View {
            ZStack {
                Indicator(percent: 1)
                    .stroke(Color(.systemFill), lineWidth: 2)
                Indicator(percent: percent)
                    .stroke(Color.accentColor, lineWidth: 2)
                    .animation(.spring(blendDuration: 0.4))
            }
            .frame(height: 2)
            .edgesIgnoringSafeArea(.horizontal)
        }
    }
}
