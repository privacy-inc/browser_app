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
    
    var body: some View {
        Popup(title: "Settings", leading: { }) {
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
                    Toggle("JavaScript", isOn: $javascript)
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
                Section {
                    NavigationLink("Location", destination: Location(session: $session))
                }
                Section {
                    NavigationLink("Default browser", destination: Default(session: $session))
                }
                Section {
                    NavigationLink("Clear data", destination: Data())
                }
                Section {
                    Button {
                        session.modal = .store
                    } label: {
                        Text("Privacy Plus")
                            .font(.callout.bold())
                            .frame(maxWidth: .greatestFiniteMagnitude)
                    }
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
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
        }
    }
}
