import SwiftUI
import Sleuth

extension History {
    struct Horizontal: View {
        @Binding var session: Session
        let pages: [Page]
        let lines: Int
        @State private var lists = [[Page]]()
        
        var body: some View {
            HStack {
                Spacer()
                ForEach(lists, id: \.self) {
                    Vertical(session: $session, pages: $0)
                    Spacer()
                }
            }
            .onAppear {
                lists = pages.reduce(into: (.init(repeating: [], count: lines), lines)) {
                    $0.1 = $0.1 < lines - 1 ? $0.1 + 1 : 0
                    $0.0[$0.1].append($1)
                }.0
            }
        }
    }
}
