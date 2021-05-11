import SwiftUI
import Archivable

@main struct App: SwiftUI.App {
    @State private var session = Session()
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .onReceive(Cloud.shared.archive) {
                    session.archive = $0
                }
        }
    }
}
