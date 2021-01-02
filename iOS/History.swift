import SwiftUI
import Combine
import Sleuth

struct History: View {
    @Binding var session: Session
    @State private var pages = [Page]()
    @Environment(\.verticalSizeClass) private var vertical
    
    var body: some View {
        GeometryReader { geo in
            if pages.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "eyeglasses")
                            .font(Font.system(size: 80).bold())
                            .foregroundColor(.accentColor)
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                if vertical == .regular {
                    Horizontal(
                        session: $session,
                        pages: $pages,
                        size: .init(size: geo.size),
                        delete: delete)
                } else {
                    Horizontal(
                        session: $session,
                        pages: $pages,
                        size: .init(size: geo.size),
                        delete: delete)
                }
            }
        }
        .animation(.easeInOut(duration: 0.4))
        .onAppear {
            var sub: AnyCancellable?
            sub = FileManager.pages.receive(on: DispatchQueue.main).sink {
                sub?.cancel()
                pages = $0
                mirror()
            }
        }
        .onReceive(session.forget) {
            pages = []
        }
    }
    
    private func delete(_ page: Page) {
        FileManager.delete(page)
        pages.firstIndex(of: page).map {
            _ = pages.remove(at: $0)
        }
        mirror()
    }
    
    private func mirror() {
        Share.history = pages.prefix(6).map(\.shared)
    }
}
