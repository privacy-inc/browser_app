import SwiftUI
import Archivable

@main struct App: SwiftUI.App {
    @State private var session = Session()
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .sheet(item: $session.modal) {
                    switch $0 {
                    case let .bookmarks(id), let .history(id):
                        Collection(session: $session, modal: $0, id: id)
                    }
                }
                .onReceive(Cloud.shared.archive) {
                    session.archive = $0
                }
        }
    }
}
