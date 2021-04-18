import SwiftUI
import Sleuth

struct Window: View {
    @Binding var session: Session
    @Environment(\.verticalSizeClass) private var vertical
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
                .sheet(item: $session.modal) {
                    switch $0 {
                    case .trackers: Trackers.List(session: $session)
                    case .store: Plus(session: $session)
                    case .froob:
                        Plus.Card(session: $session, title: "Privacy\nPlus", message: """
By purchasing Privacy Plus you support research and development at Privacy Inc and for Privacy Browser.

Privacy Plus is an In-App Purchase, it is non-consumable, meaning it is a 1 time only purchase and you can use it both on iOS and macOS.
""") {
                            session.purchases.open.send()
                        }
                    }
                }
            if session.page == nil {
                History(session: $session, horizontal: vertical == .compact)
            } else {
                Web(session: $session)
                    .padding(.init(top: 0, leading: 0,
                                   bottom: vertical == .compact ? 0 : Metrics.search.bar + Metrics.search.progress,
                                   trailing: vertical == .compact ? Metrics.search.bar + Metrics.search.progress : 0))
            }
            if vertical == .compact {
                HStack(spacing: 0) {
                    Spacer()
                    if session.page != nil {
                        GeometryReader { geo in
                            ZStack {
                                Rectangle()
                                    .fill(Color(white: 0, opacity: 0.1))
                                VStack {
                                    Rectangle()
                                        .fill(Color.accentColor)
                                        .frame(height: geo.size.height * .init(session.progress))
                                        .animation(.spring(blendDuration: 0.4))
                                    Spacer()
                                }
                            }
                        }
                        .frame(width: Metrics.search.progress)
                    }
                    VStack(spacing: Metrics.search.spacing) {
                        Searchbar(session: $session)
                    }
                    .frame(width: Metrics.search.bar)
                }
            } else {
                VStack(spacing: 0) {
                    Spacer()
                    if session.page != nil {
                        GeometryReader { geo in
                            ZStack {
                                Rectangle()
                                    .fill(Color(white: 0, opacity: 0.1))
                                HStack {
                                    Rectangle()
                                        .fill(Color.accentColor)
                                        .frame(width: geo.size.width * .init(session.progress))
                                        .animation(.spring(blendDuration: 0.4))
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: Metrics.search.progress)
                    }
                    HStack(spacing: Metrics.search.spacing) {
                        Searchbar(session: $session)
                    }
                    .frame(height: Metrics.search.bar)
                }
            }
            Field(session: $session)
                .frame(width: 0, height: 0)
        }
        .ignoresSafeArea(.keyboard)
        .animation(.easeInOut(duration: 0.3))
        .onReceive(session.purchases.open) {
            UIApplication.shared.resign()
            session.dismiss.send()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                session.modal = .store
            }
        }
    }
}
