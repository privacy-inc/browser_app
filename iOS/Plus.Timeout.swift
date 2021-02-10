import SwiftUI

extension Plus {
    struct Timemout: View {
        @Binding var session: Session
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            VStack {
                HStack {
                    Text("Upgrade to\nPrivacy Plus")
                        .font(Font.title.bold())
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding()
                Text("""
You are using the free version of Privacy and we encourage you to upgrade to Privacy Plus.

Privacy Plus is an In-App Purchase, it is consumable, meaning it is a 1 time purchase and you can use it both on iOS and macOS.
""")
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                Spacer()
                Button {
                    session.purchases.open.send()
                } label: {
                    ZStack {
                        Capsule()
                            .fill(Color.blue)
                        Text("Learn more")
                            .foregroundColor(.white)
                    }
                    .frame(width: 160, height: 40)
                }
                .contentShape(Rectangle())
                Button {
                    visible.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .font(.footnote)
                        .frame(width: 100, height: 40)
                        .foregroundColor(.secondary)
                }
                .contentShape(Rectangle())
                .padding(.vertical)
            }
            .padding()
            .onReceive(session.dismiss) {
                visible.wrappedValue.dismiss()
            }
        }
    }
}
