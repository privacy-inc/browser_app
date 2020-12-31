import SwiftUI
import Combine
import Sleuth

struct History: View {
    @Binding var session: Session
    @State private var pages = [Page]()
    @State private var sub: AnyCancellable?
    @Environment(\.verticalSizeClass) private var vertical
    
    var body: some View {
        GeometryReader { geo in
            if pages.isEmpty {
                Text("None")
            } else {
                if vertical == .regular {
                    Horizontal(session: $session, pages: pages, size: .init(size: geo.size))
                } else {
                    Horizontal(session: $session, pages: pages, size: .init(size: geo.size))
                }
            }
        }
        .edgesIgnoringSafeArea(.init())
        .onAppear(perform: refresh)
    }
    
    private func refresh() {
        guard pages.isEmpty else { return }
        sub = FileManager.pages.receive(on: DispatchQueue.main).sink {
            pages = $0
        }
    }
}
