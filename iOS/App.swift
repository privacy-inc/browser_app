import SwiftUI

@main struct App: SwiftUI.App {
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    @Environment(\.scenePhase) private var phase
    @State private var session = Session()
    private let watch = Watch()
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .onOpenURL(perform: open)
                .onReceive(watch.forget) {
//                    session.dismiss.send()
//                    session.forget()
//                    UIApplication.shared.forget()
                }
                .onReceive(session.browser.page.dropFirst()) {
                    if $0 == nil {
                        session.load()
                    }
                }
        }
        .onChange(of: phase) {
            if $0 == .active {
                if session.browser.page.value == nil {
                    session.load()
                }
                delegate.rate()
                watch.activate()
            }
        }
    }
    
    private func open(_ url: URL) {
//        session.dismiss.send()
//
//        switch url.scheme {
//        case "incognit":
//            session.resign.send()
//            url.absoluteString
//                .replacingOccurrences(of: "incognit://", with: "")
//                .removingPercentEncoding
//                .flatMap(User.engine.url)
//                .map {
//                    session.browse($0)
//                }
//        case "incognit-id":
//            session.resign.send()
//            session.browse(id: url.absoluteString.replacingOccurrences(of: "incognit-id://", with: ""))
//        case "incognit-search":
//            session.type.send(nil)
//        default:
//            session.resign.send()
//            session.browse(url)
//        }
    }
}
