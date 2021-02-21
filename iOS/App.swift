import SwiftUI
import Combine
import Sleuth

@main struct App: SwiftUI.App {
    @State var session = Session()
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    @Environment(\.scenePhase) private var phase
    private let watch = Watch()
    private let widget = Widget()
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .onOpenURL(perform: open)
                .onReceive(watch.forget, perform: session.forget.send)
                .onReceive(session.forget) {
                    FileManager.forget()
                    UIApplication.shared.forget()
                    session.pages = []
                    Share.history = []
                    Share.chart = []
                    Share.blocked = []
                    session.update.send()
                }
                .onReceive(delegate.froob) {
                    UIApplication.shared.resign()
                    session.dismiss.send()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        session.modal = .froob
                    }
                }
                .onReceive(session.save.debounce(for: .seconds(1), scheduler: DispatchQueue.main)) {
                    FileManager.save($0)
                    Share.chart.append(.init())
                    session.update.send()
                }
                .onReceive(session.update.debounce(for: .seconds(3), scheduler: DispatchQueue.main)) {
                    watch.update()
                }
                .onReceive(session.update.debounce(for: .seconds(2), scheduler: DispatchQueue.main).merge(with: session.history)) {
                    var sub: AnyCancellable?
                    sub = FileManager.pages.receive(on: DispatchQueue.main).sink {
                        sub?.cancel()
                        widget.update($0)
                        guard $0 != session.pages else { return }
                        session.pages = $0
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification, object: nil)) { _ in
                    session.typing = true
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification, object: nil)) { _ in
                    session.typing = false
                }
        }
        .onChange(of: phase) {
            if $0 == .active {
                delegate.rate()
                watch.activate()
            }
        }
    }
}
