import SwiftUI

struct Toast: View {
    @Binding var session: Session
    let message: Message
    @State private var visible = true
    
    var body: some View {
        VStack {
            if visible {
                ZStack {
                    Capsule()
                        .fill(Color(.secondarySystemBackground))
                    Capsule()
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    HStack {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 12, height: 12)
                            .padding(.leading)
                        Spacer()
                    }
                    Label(message.title, systemImage: message.icon)
                        .foregroundColor(.primary)
                        .font(.callout)
                        .padding(.vertical)
                }
                .frame(maxWidth: .greatestFiniteMagnitude)
                .fixedSize(horizontal: false, vertical: true)
                .padding([.top, .leading, .trailing])
            }
            Spacer()
        }
        .onAppear(perform: dismiss)
        .onChange(of: session.toast) {
            if $0 != nil {
                dismiss()
            }
        }
    }
    
    private func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation(.easeInOut(duration: 0.4)) {
                visible = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            session.toast = nil
        }
    }
}
