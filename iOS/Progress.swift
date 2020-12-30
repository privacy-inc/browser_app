import SwiftUI

struct Progress: View {
    var progress: CGFloat
    
    var body: some View {
        ZStack {
            Bar(progress: 1)
                .fill(Color(.systemBackground))
            Bar(progress: progress)
                .fill(Color.accentColor)
                .animation(.easeInOut(duration: 0.3))
        }
        .frame(height: 3)
    }
}

