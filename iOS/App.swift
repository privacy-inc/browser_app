import SwiftUI
import Combine
import Archivable
import Sleuth

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    @Environment(\.scenePhase) private var phase
    
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
                Cloud.shared.pull.send()
                delegate.rate()
            }
        }
    }
    
    private func open(_ url: URL) {
        switch url.scheme.flatMap(URL.Scheme.init(rawValue:)) {
//        case .privacy:
//            session.dismiss.send()
//            UIApplication.shared.resign()
//            url
//                .absoluteString
//                .dropFirst(10)
//                .removingPercentEncoding
//                .map {
//                    switch session.section {
//                    case let .browse(id):
//                        Cloud.shared.browse(id, $0) { _ in
//                            session.load.send()
//                        }
//                    case .history:
//                        Cloud.shared.browse($0) {
//                            session.section = .browse($1)
//                        }
//                    }
//                }
//        case .privacy_id:
//            session.dismiss.send()
//            UIApplication.shared.resign()
//            Int(url.absoluteString.dropFirst(12))
//                .map {
//                    Cloud.shared.revisit($0)
//                    session.section = .browse($0)
//                }
//        case .privacy_search:
//            session.dismiss.send()
//            session.section = .history
//            session.type.send()
//            session.text.send("")
//        case .privacy_forget:
//            session.dismiss.send()
//            UIApplication.shared.resign()
//            Cloud.shared.forget()
//        case .privacy_trackers:
//            if session.modal != .trackers {
//                UIApplication.shared.resign()
//                session.dismiss.send()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    session.modal = .trackers
//                }
//            }
        default:
            session.dismiss.send()
            UIApplication.shared.resign()
            Cloud.shared.navigate(url) {
                session.section = .browse($0)
            }
        }
    }
}
