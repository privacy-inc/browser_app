import SwiftUI

extension Tab.Options {
    struct Control: View {
        let title: String
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Text(title)
                        .font(.footnote)
                    Spacer()
                    Image(systemName: image)
                        .frame(width: 26)
                }
                .foregroundColor(.primary)
            }
        }
    }
}
