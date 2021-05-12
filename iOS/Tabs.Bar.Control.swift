import SwiftUI

extension Tabs.Bar {
    struct Control: View {
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Image(systemName: image)
//                    .font(.title3)
                    .frame(width: 60)
                    .frame(maxHeight: .greatestFiniteMagnitude)
                    .contentShape(Rectangle())
            }
        }
    }
}
