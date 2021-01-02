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
                }
                .onReceive(watch.forget, perform: session.forget.send)
        }
        .onChange(of: phase) {
            if $0 == .active {
                delegate.rate()
                watch.activate()
            }
        }
    }
    
    private func open(_ url: URL) {
        session.dismiss.send()
        
        switch url.scheme {
        case Scheme.privacy.rawValue:
            session.resign.send()
            url.absoluteString
                .dropFirst(Scheme.privacy.url.count)
                .removingPercentEncoding
                .flatMap(Defaults.engine.browse)
                .map {
                    switch $0 {
                    case let .search(url):
                        session.browse.send(url)
                    case let .navigate(url):
                        session.browse.send(url)
                    }
                }
        case Scheme.privacy_id.rawValue:
            session.resign.send()
            var sub: AnyCancellable?
            sub = FileManager.page(
                .init(url.absoluteString.dropFirst(Scheme.privacy_id.url.count)))
                .receive(on: DispatchQueue.main).sink {
                    sub?.cancel()
                    var page = $0
                    page.date = .init()
                    session.page = page
            }
        case Scheme.privacy_search.rawValue:
            session.type.send()
        case Scheme.privacy_forget.rawValue:
            UIApplication.shared.resign()
            session.forget.send()
        default:
            UIApplication.shared.resign()
            session.browse.send(url)
        }
    }
}
