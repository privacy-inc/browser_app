import SwiftUI
import Archivable

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @Environment(\.scenePhase) private var phase
    @WKExtensionDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .onReceive(Cloud.shared.archive) {
                    session.archive = $0
                }
        }
        .onChange(of: phase) {
            if $0 == .active {
                Cloud.shared.pull.send()
            }
        }
    }
}
