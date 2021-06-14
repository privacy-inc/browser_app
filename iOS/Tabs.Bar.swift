import SwiftUI

extension Tabs {
    struct Bar: View {
        @Binding var session: Session
        @State private var flame = false
        
        var body: some View {
            HStack(spacing: 0) {
                Control(image: "flame.fill") {
                    flame = true
                }
                .actionSheet(isPresented: $flame) {
                    .init(title: .init("FORGET"),
                          buttons: [
                            .default(.init("Close all tabs")) {
                                session
                                    .tab
                                    .ids
                                    .forEach {
                                        (session.tab[web: $0] as? Web.Coordinator)?.clear()
                                    }
                                
                                withAnimation(.spring(blendDuration: 0.4)) {
                                    session.section = .search(tabber.closeAll())
                                }
                            },
                            .default(.init("Delete cache")) {
                                Webview.clear()
                                session.toast = .init(title: "Deleted cache", icon: "trash.fill")
                            },
                            .default(.init("Delete history")) {
                                cloud.forgetBrowse()
                                session.toast = .init(title: "Deleted history", icon: "clock.fill")
                            },
                            .default(.init("Delete activity")) {
                                cloud.forgetActivity()
                                session.toast = .init(title: "Deleted activity", icon: "chart.bar.xaxis")
                            },
                            .default(.init("Delete trackers")) {
                                cloud.forgetBlocked()
                                session.toast = .init(title: "Deleted trackers", icon: "shield.lefthalf.fill")
                            },
                            .destructive(.init("Delete everything")) {
                                Webview.clear()
                                cloud.forget()
                                session.toast = .init(title: "Deleted everything", icon: "flame.fill")
                            },
                            .cancel()])
                }
                
                Control(image: "chart.bar.xaxis") {
                    session.modal = .activity
                }
                
                Control(image: "plus") {
                    session.modal = nil
                    withAnimation(.spring(blendDuration: 0.4)) {
                        session.section = .search(tabber.new())
                    }
                    session.search.send()
                }
                
                Control(image: "shield.lefthalf.fill") {
                    session.modal = .trackers
                }
                
                Control(image: "slider.horizontal.3") {
                    session.modal = .settings
                }
            }
            .padding(.horizontal)
            .frame(height: 34)
            .padding(.vertical, 10)
        }
    }
}
