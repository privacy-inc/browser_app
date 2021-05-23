import SwiftUI
import Archivable

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
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
                    case .settings:
                        Settings(session: $session)
                    case .trackers:
                        Trackers(session: $session)
                    case .activity:
                        Activity(session: $session)
                    case .store:
                        EmptyView()
                    case .froob:
                        EmptyView()
                    }
                }
                .onReceive(Cloud.shared.archive) {
                    session.archive = $0
                }
                .onReceive(session.purchases.open) {
                    session.modal = .store
                }
                .onReceive(delegate.froob) {
                    session.modal = .froob
                }
        }
        .onChange(of: phase) {
            if $0 == .active {
                Cloud.shared.pull.send()
            }
        }
    }
}
