import SwiftUI
import Sleuth

struct Settings: View {
    @Binding var session: Session
    @State private var engine = Engine.google
    @State private var dark = true
    @State private var javascript = true
    @State private var http = true
    @State private var trackers = true
    @State private var cookies = true
    @State private var popups = true
    @State private var ads = true
    @State private var screen = true
    @State private var third = true
    @State private var timers = true
    
    var body: some View {
        Popup(title: "Settings", leading: {
            Button {
                session.modal = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    session.modal = .store
                }
            } label: {
                HStack {
                    Text("Privacy")
                        .font(.callout)
                    Image(systemName: "plus")
                        .font(.body)
                }
                .padding([.top, .bottom, .trailing])
            }
            .contentShape(Rectangle())
        }) {
            List {
                Section(header: Text("Search Engine")) {
                    Picker("Search Engine", selection: $engine) {
                        Text(verbatim: "Google")
                            .foregroundColor(.white)
                            .tag(Engine.google)
                        Text(verbatim: "Ecosia")
                            .foregroundColor(.white)
                            .tag(Engine.ecosia)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Features")) {
                    Toggle("Force dark mode", isOn: $dark)
                    Toggle("Block pop-ups", isOn: $popups)
                    Toggle("Remove ads", isOn: $ads)
                    Toggle("Remove screen blockers", isOn: $screen)
                }
                Section(header: Text("Security")) {
                    Toggle("Force secure connections", isOn: $http)
                }
                Section(header: Text("Privacy")) {
                    Toggle("Anti tracker protection", isOn: $trackers)
                    Toggle("Anti cookies protection", isOn: $cookies)
                }
                Section(header: Text("JavaScript")) {
                    Toggle("Scripts enabled", isOn: $javascript)
                    Toggle("Stop scripts when loaded", isOn: $timers)
                    Toggle("Block third-party scripts", isOn: $third)
                }
                Section {
                    NavigationLink("Location", destination: Location(session: $session))
                }
                Section {
                    NavigationLink("Default browser", destination: Default(session: $session))
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .listStyle(GroupedListStyle())
        }
        .onChange(of: engine) {
            cloud.engine($0)
        }
        .onChange(of: dark) {
            cloud.dark($0)
        }
        .onChange(of: javascript) {
            cloud.javascript($0)
        }
        .onChange(of: http) {
            cloud.http(!$0)
        }
        .onChange(of: trackers) {
            cloud.trackers(!$0)
        }
        .onChange(of: cookies) {
            cloud.cookies(!$0)
        }
        .onChange(of: popups) {
            cloud.popups(!$0)
        }
        .onChange(of: ads) {
            cloud.ads(!$0)
        }
        .onChange(of: screen) {
            cloud.screen(!$0)
        }
        .onChange(of: third) {
            cloud.third(!$0)
        }
        .onChange(of: timers) {
            cloud.timers(!$0)
        }
        .onAppear {
            engine = session.archive.settings.engine
            dark = session.archive.settings.dark
            javascript = session.archive.settings.javascript
            http = !session.archive.settings.http
            trackers = !session.archive.settings.trackers
            cookies = !session.archive.settings.cookies
            popups = !session.archive.settings.popups
            ads = !session.archive.settings.ads
            screen = !session.archive.settings.screen
            third = !session.archive.settings.third
            timers = !session.archive.settings.timers
        }
    }
}
