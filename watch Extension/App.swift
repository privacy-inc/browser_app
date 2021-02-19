import SwiftUI
import WatchConnectivity
import Sleuth

@main struct App: SwiftUI.App {
    @ObservedObject private var delegate = Delegate()
    @State private var alert = false
    @State private var tab = 0
    @State private var formatter = NumberFormatter()
    
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
                    VStack {
                        HStack {
                            Text(NSNumber(value: delegate.blocked.count), formatter: formatter)
                                .font(Font.largeTitle.bold())
                                .padding(.leading)
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "shield.lefthalf.fill")
                                .font(.title2)
                                .padding(.trailing)
                        }
                    }
                    .padding()
                }
                .tag(1)
                ZStack {
                    Color("Background")
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack {
                            Text("Forget")
                                .foregroundColor(.secondary)
                                .padding(.leading)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(.leading)
                    Neumorphic(image: "flame.fill")
                        .onTapGesture {
                            alert = true
                        }
                        .alert(isPresented: $alert) {
                            Alert(title: .init("Forget everything?"),
                                  primaryButton: .default(.init("Cancel")),
                                  secondaryButton: .destructive(.init("Forget")) {
                                    delegate.forget()
                            })
                        }
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .onAppear {
                formatter.numberStyle = .decimal
                if WCSession.default.activationState != .activated {
                    WCSession.default.delegate = delegate
                    WCSession.default.activate()
                }
            }
            .onChange(of: tab) { _ in
                delegate.refresh()
            }
        }
    }
}
