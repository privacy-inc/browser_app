import SwiftUI

extension Tab.Bar {
    struct Control: View {
        var disabled = false
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Image(systemName: image)
                    .font(.title3)
                    .foregroundColor(disabled ? .init(.tertiaryLabel) : .primary)
                    .frame(width: 60)
                    .frame(maxHeight: .greatestFiniteMagnitude)
                    .contentShape(Rectangle())
            }
            .disabled(disabled)
        }
    }
}
