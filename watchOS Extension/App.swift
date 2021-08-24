import SwiftUI
import Archivable
import Sleuth

let cloud = Cloud.new
@main struct App: SwiftUI.App {
    @State private var archive = Archive.new
    @Environment(\.scenePhase) private var phase
    @WKExtensionDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Activity(archive: archive)
                Trackers(archive: archive, trackers: archive.trackers(.attempts))
                Forget()
            }
            .tabViewStyle(PageTabViewStyle())
            .onReceive(cloud.archive) {
                archive = $0
            }
        }
        .onChange(of: phase) {
            if $0 == .active {
                cloud.pull.send()
            }
        }
    }
}
