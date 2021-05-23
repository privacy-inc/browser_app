import SwiftUI

struct Message: View {
    let title: String
    let message: String
    let action: () -> Void
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        VStack {
            Text(title)
                .font(Font.title.bold())
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            Text(message)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            Spacer()
            Button {
                visible.wrappedValue.dismiss()
                action()
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
    }
}
