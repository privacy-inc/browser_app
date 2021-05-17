import SwiftUI
import Archivable

@main struct App: SwiftUI.App {
    @State private var session = Session()
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .sheet(item: $session.modal) {
                    switch $0 {
                    case .bookmarks, .recent:
                        Collection(session: $session, modal: $0)
                    }
                }
                .onReceive(Cloud.shared.archive) {
                    session.archive = $0
                }
        }
    }
}
