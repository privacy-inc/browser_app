import SwiftUI

extension History {
    struct Vertical: View {
        @Binding var session: Session
        let lines: Int
        let index: Int
        
        var body: some View {
            VStack {
                ForEach(0 ..< session.pages.value.count) {
                    if ($0 / lines) == index {
                        Circle()
                    }
                }
            }
            .frame(width: 150)
        }
    }
}
