import SwiftUI
import Combine
import Sleuth

@main struct App: SwiftUI.App {
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    @Environment(\.scenePhase) private var phase
    @State private var session = Session()
    private let watch = Watch()
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .onOpenURL(perform: open)
                .onReceive(session.forget) {
                    FileManager.forget()
                    UIApplication.shared.forget()
                    Share.history = []
                    Share.chart = []
                    Share.blocked = []
                    session.update.send()
                }
                .onReceive(watch.forget, perform: session.forget.send)
                .onReceive(session.save.debounce(for: .seconds(2), scheduler: DispatchQueue.main)) {
                    FileManager.save($0)
                    Share.chart.append(.init())
                    session.update.send()
                }
        }
        .onChange(of: phase) {
            if $0 == .active {
                delegate.rate()
                watch.activate(session.update)
            }
        }
    }
    
    private func open(_ url: URL) {
        session.dismiss.send()
        let current = session.page
        switch url.scheme.flatMap(Scheme.init(rawValue:)) {
        case .privacy:
            session.resign.send()
            url.absoluteString
                .dropFirst(Scheme.privacy.url.count)
                .removingPercentEncoding
                .flatMap(Defaults.engine.browse)
                .map {
                    let url: URL
                    switch $0 {
                    case let .search(search):
                        url = search
                    case let .navigate(navigate):
                        url = navigate
                    }
                    
                    session.page = .init(url: url)
                    if current != nil {
                        session.browse.send(url)
                    }
                }
        case .privacy_id:
            session.resign.send()
            var sub: AnyCancellable?
            sub = FileManager.page(
                .init(url.absoluteString.dropFirst(Scheme.privacy_id.url.count)))
                .receive(on: DispatchQueue.main).sink {
                    sub?.cancel()
                    var page = $0
                    page.date = .init()
                    session.page = page
                    
                    if current != nil {
                        session.browse.send(url)
                    }
            }
        case .privacy_search:
            session.page = nil
            session.type.send()
        case .privacy_forget:
            UIApplication.shared.resign()
            session.forget.send()
        default:
            UIApplication.shared.resign()
            session.page = .init(url: url)
            
            if current != nil {
                session.browse.send(url)
            }
        }
    }
}
