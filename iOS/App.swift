import SwiftUI
import Combine
import Sleuth

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    @Environment(\.scenePhase) private var phase
    private let widget = Widget()
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .onOpenURL(perform: open)
                .onReceive(delegate.froob) {
                    UIApplication.shared.resign()
                    session.dismiss.send()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        session.modal = .froob
                    }
                }
        }
        .onChange(of: phase) {
            if $0 == .active {
                delegate.rate()
            }
        }
    }
    
    private func open(_ url: URL) {
        switch url.scheme.flatMap(Scheme.init(rawValue:)) {
        case .privacy:
            session.dismiss.send()
            UIApplication.shared.resign()
            url
                .absoluteString
                .dropFirst(Scheme.privacy.url.count)
                .removingPercentEncoding
                .map {
                    var sub: AnyCancellable?
                    sub = Synch
                        .cloud
                        .browse($0)
                        .receive(on: DispatchQueue.main)
                        .sink {
                            sub?.cancel()
                            $0.map {
                                session.section = .browse($0.1)
                            }
                        }
                }
        case .privacy_id:
            session.dismiss.send()
            UIApplication.shared.resign()
            Int(url.absoluteString.dropFirst(Scheme.privacy_id.url.count))
                .map {
                    Synch.cloud.revisit($0)
                    session.section = .browse($0)
                }
        case .privacy_search:
            session.dismiss.send()
            session.section = .history
            session.type.send()
            session.text.send("")
        case .privacy_forget:
            session.dismiss.send()
            UIApplication.shared.resign()
            Synch.cloud.forget()
        case .privacy_trackers:
            if session.modal != .trackers {
                UIApplication.shared.resign()
                session.dismiss.send()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    session.modal = .trackers
                }
            }
        default:
            session.dismiss.send()
            UIApplication.shared.resign()
            var sub: AnyCancellable?
            sub = Synch
                .cloud
                .navigate(url)
                .sink {
                    sub?.cancel()
                    session.section = .browse($0)
                }
        }
    }
}
