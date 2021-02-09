import SwiftUI
import WidgetKit
import Combine
import Sleuth

struct History: View {
    @Binding var session: Session
    
    @State private var pages = [Page]() {
        didSet {
            let history = pages.prefix(6).map(\.shared)
            if history != Share.history {
                Share.history = history
                WidgetCenter.shared.reloadTimelines(ofKind: "History")
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            if pages.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("logo")
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                if UIDevice.current.orientation.isLandscape {
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
        .onAppear(perform: refresh)
        .onReceive(session.forget) {
            pages = []
        }
        .onReceive(session.update) {
            refresh()
        }
    }
    
    private func refresh() {
        var sub: AnyCancellable?
        sub = FileManager.pages.receive(on: DispatchQueue.main).sink {
            sub?.cancel()
            pages = $0
        }
    }
    
    private func delete(_ page: Page) {
        FileManager.delete(page)
        pages.firstIndex(of: page).map {
            _ = pages.remove(at: $0)
        }
    }
}
