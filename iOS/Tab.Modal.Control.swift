import SwiftUI

extension Tab.Modal {
    struct Control: View {
        let title: String
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Label(title, systemImage: image)
                    .font(.callout)
                    .foregroundColor(.primary)
                    .frame(height: 50)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(.horizontal)
                    .contentShape(Rectangle())
            }
        }
    }
}
