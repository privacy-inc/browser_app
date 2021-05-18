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
                        Collection(session: $session, id: id, modal: $0)
                    case let .info(id):
                        Tab.Info(session: $session, id: id)
                    case let .options(id):
                        Tab.Options(session: $session, id: id)
                    }
                }
                .onReceive(Cloud.shared.archive) {
                    session.archive = $0
                }
        }
    }
}
