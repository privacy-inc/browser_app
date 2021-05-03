import SwiftUI
import Archivable
import Sleuth

@main struct App: SwiftUI.App {
    @State private var alert = false
    @State private var formatter = NumberFormatter()
    @State private var activity = [Date]()
    @State private var blocked = 0
    @Environment(\.scenePhase) private var phase
    @WKExtensionDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ZStack {
                    Color("Background")
                        .edgesIgnoringSafeArea(.all)
                    Chart(chart: activity)
                        .padding()
                }
                ZStack {
                    Color("Background")
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack {
                            Text(NSNumber(value: blocked), formatter: formatter)
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
                                    Cloud.shared.forget()
                            })
                        }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .onReceive(Cloud.shared.archive) {
                activity = $0.activity
                blocked = $0.blocked.map(\.value.count).reduce(0, +)
            }
            .onAppear {
                Cloud.shared.pull.send()
                formatter.numberStyle = .decimal
            }
        }
        .onChange(of: phase) {
            if $0 == .active {
                Cloud.shared.pull.send()
            }
        }
    }
}
