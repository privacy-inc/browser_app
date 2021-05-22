import SwiftUI
import Archivable
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
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Search Engine")) {
                    Picker("Search Engine", selection: $engine) {
                        Text("Google")
                            .foregroundColor(.white)
                            .tag(Engine.google)
                        Text("Ecosia")
                            .foregroundColor(.white)
                            .tag(Engine.ecosia)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Features")) {
                    Toggle("Force dark mode", isOn: $dark)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    Toggle("JavaScript", isOn: $javascript)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    Toggle("Block pop-ups", isOn: $popups)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    Toggle("Remove ads", isOn: $ads)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    Toggle("Remove screen blockers", isOn: $screen)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                }
                Section(header: Text("Security")) {
                    Toggle("Force secure connections", isOn: $http)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                }
                Section(header: Text("Privacy")) {
                    Toggle("Anti tracker protection", isOn: $trackers)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    Toggle("Anti cookies protection", isOn: $cookies)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                }
                Section {
                    NavigationLink("Location", destination: Location(session: $session))
                }
                Section {
                    NavigationLink("Default browser", destination: Default(session: $session))
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings", displayMode: .large)
            .navigationBarItems(trailing:
                                    Button {
                                        visible.wrappedValue.dismiss()
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.secondary)
                                            .frame(width: 30, height: 50)
                                            .padding(.leading, 40)
                                            .contentShape(Rectangle())
                                    })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onChange(of: engine) {
            Cloud.shared.engine($0)
        }
        .onChange(of: dark) {
            Cloud.shared.dark($0)
        }
        .onChange(of: javascript) {
            Cloud.shared.javascript($0)
        }
        .onChange(of: http) {
            Cloud.shared.http(!$0)
        }
        .onChange(of: trackers) {
            Cloud.shared.trackers(!$0)
        }
        .onChange(of: cookies) {
            Cloud.shared.cookies(!$0)
        }
        .onChange(of: popups) {
            Cloud.shared.popups(!$0)
        }
        .onChange(of: ads) {
            Cloud.shared.ads(!$0)
        }
        .onChange(of: screen) {
            Cloud.shared.screen(!$0)
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
