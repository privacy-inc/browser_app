import SwiftUI

extension Tab {
    struct Loading: View {
        @Binding var session: Session
        let id: UUID
        @State private var show = AnimatablePair(Double(), Double())
        
        var body: some View {
            VStack {
                Indicator(show: show)
                    .stroke(Color.accentColor, lineWidth: 3)
                    .edgesIgnoringSafeArea(.horizontal)
                Spacer()
            }
            .onChange(of: session.tab[progress: id]) { value in
                show.first = 0
                withAnimation(.easeInOut(duration: 0.3)) {
                    show.second = value
                }
                if value == 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            show = .init(1, 1)
                        }
                    }
                }
            }
        }
    }
}
