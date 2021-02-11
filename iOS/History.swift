import SwiftUI
import Sleuth

struct History: View {
    @Binding var session: Session
    let horizontal: Bool
    
    var body: some View {
        if horizontal {
            GeometryReader {
                Dynamic(session: $session, size: .init(size: $0.size), horizontal: horizontal)
            }
        } else {
            GeometryReader {
                Dynamic(session: $session, size: .init(size: $0.size), horizontal: horizontal)
            }
        }
    }
}
