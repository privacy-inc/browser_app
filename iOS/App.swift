import SwiftUI
import Archivable
import Sleuth

let cloud = Cloud.new
let tabber = Sleuth.Tab()
let purchases = Purchases()
@main struct App: SwiftUI.App {
    @State private var session = Session()
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .onOpenURL(perform: open)
                .sheet(item: $session.modal, content: modal)
                .onReceive(cloud.archive) {
                    session.archive = $0
                }
                .onReceive(tabber.items) {
                    session.tab = $0
                }
                .onReceive(purchases.open) {
                    change(.store)
                }
                .onReceive(delegate.froob) {
                    change(.froob)
                }
        }
        .onChange(of: phase) {
            if $0 == .active {
                cloud.pull.send()
            }
        }
    }
    
    private func open(_ url: URL) {
        cloud
            .notifier
            .notify(queue: .main) {
                session.modal = nil
                
                switch url.scheme {
                case "privacy":
                    switch url.host {
                    case "history":
                        UIApplication.shared.resign()
                        Int(url.lastPathComponent)
                            .map { browse in
                                let complete = {
                                    let id = tabber.new()
                                    cloud.revisit(browse)
                                    tabber.browse(id, browse)
                                    session.section = .tab(id)
                                }
                                switch session.section {
                                case let .tab(id):
                                    if session.tab[state: id].isBrowse {
                                        session.section = .tabs(nil)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            complete()
                                        }
                                    } else {
                                        complete()
                                    }
                                default:
                                    complete()
                                }
                            }
                    case "bookmark":
                        UIApplication.shared.resign()
                        Int(url.lastPathComponent)
                            .map { index in
                                let complete = {
                                    let id = tabber.new()
                                    cloud
                                        .open(index) {
                                            tabber.browse(id, $0)
                                        }
                                    session.section = .tab(id)
                                }
                                switch session.section {
                                case let .tab(id):
                                    if session.tab[state: id].isBrowse {
                                        session.section = .tabs(nil)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            complete()
                                        }
                                    } else {
                                        complete()
                                    }
                                default:
                                    complete()
                                }
                            }
                    default:
                        switch session.section {
                        case let .tab(id):
                            session.section = .search(id)
                        case .tabs:
                            session.section = .search(tabber.new())
                        default:
                            break
                        }
                    }
                default:
                    UIApplication.shared.resign()
                    let complete = {
                        cloud
                            .navigate(url) { browse, _ in
                                let id = tabber.new()
                                tabber.browse(id, browse)
                                session.section = .tab(id)
                            }
                    }
                    
                    switch session.section {
                    case let .tab(id):
                        if session.tab[state: id].isBrowse {
                            session.newTab.send(url)
                        } else {
                            complete()
                        }
                    default:
                        complete()
                    }
            }
        }
    }
    
    private func change(_ modal: Session.Modal) {
        guard modal != session.modal else { return }
        if session.modal == nil {
            session.modal = modal
        } else {
            session.modal = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                session.modal = modal
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
            Trackers(session: $session)
        case .activity:
            Activity(session: $session)
        case .froob:
            Info.Froob(session: $session)
        case .store:
            Store()
        }
    }
}
