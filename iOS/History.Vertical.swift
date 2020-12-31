import SwiftUI
import Sleuth

extension History {
    struct Vertical: View {
        @Binding var session: Session
        let pages: [Page]
        
        var body: some View {
            VStack {
                ForEach(pages) {
                    Cell(page: $0) {
                        
                    } action: {
                        
                    }
                }
                Spacer()
            }
        }
    }
}
