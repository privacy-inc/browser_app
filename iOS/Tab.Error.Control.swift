import SwiftUI

extension Tab.Error {
    struct Control: View {
        let title: String
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.tertiarySystemFill))
                    Label(title, systemImage: image)
                        .padding(.horizontal)
                        .font(.callout)
                        .foregroundColor(.primary)
                }
                .frame(height: 50)
                .frame(maxWidth: 300)
            }
        }
    }
}
