import SwiftUI
import Combine
import Sleuth

struct History: View {
    @Binding var session: Session
    @State private var pages = [Page]()
    @State private var sub: AnyCancellable?
    
    var body: some View {
        GeometryReader { geo in
            if pages.isEmpty {
                Text("None")
            } else {
                ScrollView {
                    Horizontal(session: $session, pages: pages, lines: .init(geo.size.width / 150))
                }
            }
        }
        .onAppear(perform: refresh)
    }
    
    private func refresh() {
        guard pages.isEmpty else { return }
        sub = FileManager.pages.receive(on: DispatchQueue.main).sink {
            pages = $0
        }
    }
}
