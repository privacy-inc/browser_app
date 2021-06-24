import SwiftUI

extension Tabs {
    struct Bar: View {
        @Binding var session: Session
        let closeAll: () -> Void
        @State private var flame = false
        
        var body: some View {
            HStack(spacing: 0) {
                Control(image: "flame.fill") {
                    flame = true
                }
                .actionSheet(isPresented: $flame) {
                    .init(title: .init("FORGET"),
                          buttons: [
                            .default(.init("Cache")) {
                                Webview.clear()
                                session.toast = .init(title: "Forgot cache", icon: "trash.fill")
                            },
                            .default(.init("History")) {
                                cloud.forgetBrowse()
                                session.toast = .init(title: "Forgot history", icon: "clock.fill")
                                closeAll()
                            },
                            .default(.init("Activity")) {
                                cloud.forgetActivity()
                                session.toast = .init(title: "Forgot activity", icon: "chart.bar.xaxis")
                            },
                            .default(.init("Trackers")) {
                                cloud.forgetBlocked()
                                session.toast = .init(title: "Forgot trackers", icon: "shield.lefthalf.fill")
                            },
                            .destructive(.init("Everything")) {
                                Webview.clear()
                                cloud.forget()
                                session.toast = .init(title: "Forgot everything", icon: "flame.fill")
                                closeAll()
                            },
                            .cancel()])
                }
                
                Control(image: "chart.bar.xaxis") {
                    session.modal = .activity
                }
                
                Control(image: "plus", font: .title2) {
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
            .frame(height: 34)
            .padding(.vertical, 10)
        }
    }
}
