import SwiftUI
import WatchConnectivity
import Sleuth

@main struct App: SwiftUI.App {
    @ObservedObject var delegate = Delegate()
    @State private var alert = false
    @State private var tab = 0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $tab) {
                ZStack {
                    Color("Background")
                        .edgesIgnoringSafeArea(.all)
                    Chart(chart: delegate.chart)
                        .padding()
                }
                .tag(0)
                ZStack {
                    Color("Background")
                        .edgesIgnoringSafeArea(.all)
                    Neumorphic(image: "flame")
                        .onTapGesture {
                            alert = true
                        }
                        .alert(isPresented: $alert) {
                            Alert(title: .init("Forget everything?"),
                                  primaryButton: .default(.init("Cancel")),
                                  secondaryButton: .destructive(.init("Forget")) {
                                    delegate.chart = []
                                    delegate.forget()
                            })
                        }
                }
                .tag(1)
            }
            .tabViewStyle(PageTabViewStyle())
            .onAppear {
                if WCSession.default.activationState != .activated {
                    WCSession.default.delegate = delegate
                    WCSession.default.activate()
                }
            }
            .onChange(of: tab) { _ in
                delegate.chart = Share.chart
            }
        }
    }
}
