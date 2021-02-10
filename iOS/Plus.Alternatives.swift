import SwiftUI

extension Plus {
    struct Alternatives: View {
        @Binding var session: Session
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            VStack {
                HStack {
                    Text("Alternatives\nto purchasing")
                        .font(Font.title.bold())
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding()
                Text("""
We ask you to purchase Privacy Plus only if you consider it a good product, if you think is helping you in some way and if you feel the difference betweena mainstream browser and Privacy.

But we are not going to force you to buy it; you will be reminded from time to time that it would be a good idea if you support us with your purchase, but you can as easily ignore the pop-up and continue using Privacy.

We believe we can help you browse securely and privatly even if you can't support us at the moment.
""")
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                Spacer()
                Button {
                    visible.wrappedValue.dismiss()
                } label: {
                    ZStack {
                        Capsule()
                            .fill(Color.blue)
                        Text("Accept")
                            .foregroundColor(.white)
                    }
                    .frame(width: 140, height: 40)
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
