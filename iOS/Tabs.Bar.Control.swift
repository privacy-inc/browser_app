import SwiftUI

extension Tabs.Bar {
    struct Control: View {
        let image: String
        var font = Font.title3
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Image(systemName: image)
                    .font(font)
                    .frame(width: 64)
                    .frame(maxHeight: .greatestFiniteMagnitude)
                    .foregroundColor(.secondary)
                    .contentShape(Rectangle())
            }
        }
    }
}
