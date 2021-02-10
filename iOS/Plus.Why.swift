import SwiftUI

extension Plus {
    struct Why: View {
        @Binding var session: Session
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            VStack {
                HStack {
                    Text("Why purchasing\nPrivacy Plus?")
                        .font(Font.title.bold())
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding()
                Text("""
By upgrading to Privacy Plus you are supporting the development and research necessary to fulfil our mission of bringing the most secure and private browser to iOS and macOS.

Compared to other browser alternatives, we at Privacy Inc. are an independent team, we don't have the support of big international corporations.

Furthermore, besides our In-App Purchases we don't monetize using any other mean, i.e. we don't monetize with your personal data, and we don't provide advertisements, in fact, is in our mission to remove ads from the web.
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
