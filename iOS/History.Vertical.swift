import SwiftUI
import Sleuth

extension History {
    struct Vertical: View {
        @Binding var session: Session
        let pages: [Page]
        let delete: (Page) -> Void
        
        var body: some View {
            VStack {
                ForEach(pages) { page in
                    Cell(page: page, delete: delete) {
                        var page = page
                        page.date = .init()
                        session.page = page
                    }
                }
            }
        }
    }
}
