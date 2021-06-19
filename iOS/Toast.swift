import SwiftUI

struct Toast: View {
    @Binding var session: Session
    let message: Message
    @State private var visible = true
    
    var body: some View {
        VStack {
            if visible {
                ZStack {
                    Blur(style: .systemThinMaterial)
                        .edgesIgnoringSafeArea([.top, .leading, .trailing])
                    VStack {
                        Label(message.title, systemImage: message.icon)
                            .font(.callout)
                            .padding(.vertical)
                        Rectangle()
                            .fill(Color(.systemBackground).opacity(0.2))
                            .frame(height: 1)
                    }
                }
                .frame(maxWidth: .greatestFiniteMagnitude)
                .fixedSize(horizontal: false, vertical: true)
                .onTapGesture(perform: dismiss)
                Spacer()
            }
        }
        .allowsHitTesting(visible)
        .accessibilityAddTraits(.isModal)
        .onAppear(perform: timer)
    }
    
    private func timer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            dismiss()
        }
    }
    
    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.4)) {
            visible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            session.toast = nil
        }
    }
}
