import SwiftUI
import Archivable

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .onOpenURL(perform: open)
                .sheet(item: $session.modal, content: modal)
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
    
    private func open(_ url: URL) {
        Cloud
            .shared
            .notifier
            .notify(queue: .main) {
                session.modal = nil
                
                switch url.scheme {
                case "privacy":
                    switch url.host {
                    case "id":
                        UIApplication.shared.resign()
                        Int(url.lastPathComponent)
                            .map {
                                switch session.section {
                                case let .tab(id):
                                    session.tab.browse(id, $0)
                                    Cloud.shared.revisit($0) {
                                        session.load.send((id: id, access: $0))
                                    }
                                default:
                                    let id = session.tab.new()
                                    session.tab.browse(id, $0)
                                    session.section = .tab(id)
                                }
                            }
                    default:
                        switch session.section {
                        case let .tab(id):
                            session.section = .search(id)
                        case .tabs:
                            session.section = .search(session.tab.new())
                        default:
                            break
                        }
                    }
                default:
                    UIApplication.shared.resign()
                    Cloud.shared.navigate(url) { browse, access in
                        switch session.section {
                        case let .tab(id):
                            session.tab.browse(id, browse)
                            session.load.send((id: id, access: access))
                        default:
                            let id = session.tab.new()
                            session.tab.browse(id, browse)
                            session.section = .tab(id)
                        }
                    }
            }
        }
    }
    
    @ViewBuilder private func modal(_ modal: Session.Modal) -> some View {
        switch modal {
        case let .bookmarks(id), let .history(id):
            Collection(session: $session, id: id, modal: modal)
        case let .info(id):
            Tab.Info(session: $session, id: id)
        case let .options(id):
            Tab.Options(session: $session, id: id)
        case .settings:
            Settings(session: $session)
        case .trackers:
            Trackers(session: $session, trackers: session.archive.trackers)
        case .activity:
            Activity(session: $session)
        case .store:
            Store(session: $session)
        case .froob:
            Info.Froob(session: $session)
        }
    }
}
