import SwiftUI
import Sleuth

extension History {
    struct Horizontal: View {
        @Binding var session: Session
        let pages: [Page]
        let size: Size
        @State private var lists = [[Page]]()
        
        var body: some View {
            ScrollView {
                HStack {
                    Spacer()
                    ForEach(lists, id: \.self) {
                        Vertical(session: $session, pages: $0)
                            .frame(width: size.width)
                        Spacer()
                    }
                }
            }
            .onAppear {
                lists = pages.reduce(into: (.init(repeating: [], count: size.lines), size.lines)) {
                    $0.1 = $0.1 < size.lines - 1 ? $0.1 + 1 : 0
                    $0.0[$0.1].append($1)
                }.0
            }
        }
    }
}
