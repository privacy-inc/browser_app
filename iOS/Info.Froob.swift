import SwiftUI

extension Info {
    struct Froob: View {
        @Binding var session: Session
        
        var body: some View {
            Message(
                title: "Privacy\nPlus",
                message: """
    By purchasing Privacy Plus you support research and development at Privacy Inc and for Privacy Browser.

    Privacy Plus is an In-App Purchase, it is non-consumable, meaning it is a 1 time only purchase and you can use it both on iOS and macOS.
    """) {
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
