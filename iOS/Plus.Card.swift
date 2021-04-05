import SwiftUI

extension Plus {
    struct Card: View {
        @Binding var session: Session
        let title: String
        let message: String
        let action: (() -> Void)?
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            VStack {
                HStack {
                    Text(title)
                        .font(Font.title.bold())
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding()
                Text(message)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                Spacer()
                Button {
                    visible.wrappedValue.dismiss()
                    action?()
                } label: {
                    ZStack {
                        Capsule()
                            .fill(Color.blue)
                        Text("Accept")
                            .font(Font.footnote.bold())
                            .foregroundColor(.white)
                    }
                    .frame(width: 140, height: 36)
                }
                .contentShape(Rectangle())
                .padding(.bottom)
            }
            .padding()
            .onReceive(session.dismiss) {
                visible.wrappedValue.dismiss()
            }
        }
    }
}
