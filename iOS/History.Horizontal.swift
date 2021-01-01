import SwiftUI
import Sleuth

extension History {
    struct Horizontal: View {
        @Binding var session: Session
        @Binding var pages: [Page]
        let size: Size
        let delete: (Page) -> Void
        @State private var lists = [[Page]]()
        
        var body: some View {
            ScrollView {
                HStack(alignment: .top) {
                    Spacer()
                    ForEach(lists, id: \.self) {
                        Vertical(session: $session, pages: $0, delete: delete)
                            .frame(width: size.width)
                        Spacer()
                    }
                }
            }
            .onAppear(perform: refresh)
            .onChange(of: pages) { _ in
                refresh()
            }
        }
        
        private func refresh() {
            lists = pages.reduce(into: (.init(repeating: [], count: size.lines), size.lines)) {
                $0.1 = $0.1 < size.lines - 1 ? $0.1 + 1 : 0
                $0.0[$0.1].append($1)
            }.0
        }
    }
}
