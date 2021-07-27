import SwiftUI

extension Info {
    struct Froob: View {
        @Binding var session: Session
        
        var body: some View {
            Message(
                title: "Privacy\nPlus\n\n",
                message: Purchases.froob) {
                Button {
                    session.modal = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        session.modal = .store
                    }
                } label: {
                    ZStack {
                        Capsule()
                            .fill(Color.blue)
                        Text("Accept")
                            .font(Font.footnote.bold())
                            .foregroundColor(.white)
                    }
                    .frame(width: 140, height: 36)
                    .contentShape(Rectangle())
                }
                .padding(.bottom)
            }
        }
    }

}
