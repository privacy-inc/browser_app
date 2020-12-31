import SwiftUI

extension History {
    struct Horizontal: View {
        @Binding var session: Session
        let lines: Int
        
        var body: some View {
            HStack {
                ForEach(0 ..< lines) {
                    Vertical(session: $session, lines: lines, index: $0)
                }
            }
            .onAppear {
                print(lines)
            }
        }
    }
}
