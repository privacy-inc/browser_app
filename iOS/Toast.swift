import SwiftUI

struct Toast: View {
    @Binding var session: Session
    let message: Message
    
    var body: some View {
        VStack {
            ZStack {
                Capsule()
                    .fill(Color.accentColor)
                Capsule()
                    .stroke(Color.black, lineWidth: 1)
                Label(message.title, systemImage: message.icon)
                    .foregroundColor(.black)
                    .font(.callout)
                    .padding(.vertical)
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .fixedSize(horizontal: false, vertical: true)
            .padding([.top, .leading, .trailing])
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            session.toast = nil
        }
    }
}
