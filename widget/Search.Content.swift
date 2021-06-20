import SwiftUI

extension Search {
    struct Content: View {
        let entry: Entry
        
        var body: some View {
            ZStack {
                Image("search")
                Text("Privacy")
                    .font(.callout)
                    .foregroundColor(.init(.tertiaryLabel))
                    .padding([.leading, .top], 24)
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
            }
        }
    }
}
