import SwiftUI

extension History {
    struct Vertical<Content>: View where Content : View  {
        let content: Content
        
        @inlinable public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            VStack(spacing: 0) {
                content
            }
        }
    }
}
