import SwiftUI

extension Tab.Modal {
    struct Control: View {
        let title: String
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.systemBackground).opacity(0.2))
                    HStack {
                        Text(title)
                        Spacer()
                        Image(systemName: image)
                    }
                    .padding(.horizontal)
                    .font(.callout)
                    .foregroundColor(.primary)
                }
                .frame(height: 52)
            }
        }
    }
}
