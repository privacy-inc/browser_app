import SwiftUI

extension History {
    struct Medium<Content>: View where Content : View  {
        let content: Content
        
        @inlinable public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            HStack(alignment: .top, spacing: 0) {
                Spacer()
                content
                Spacer()
            }
            .padding()
        }
    }
}
