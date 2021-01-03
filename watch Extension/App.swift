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
                Chart(chart: delegate.chart)
                    .padding()
                    .tag(0)
                ZStack {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 60, height: 60)
                    Image(systemName: "flame")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .onTapGesture {
                            alert = true
                        }
                }
                .tag(1)
                .alert(isPresented: $alert) {
                    Alert(title: .init("Forget everything?"),
                          primaryButton: .default(.init("Cancel")),
                          secondaryButton: .destructive(.init("Forget")) {
                            delegate.chart = []
                            delegate.forget()
                    })
                }
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
