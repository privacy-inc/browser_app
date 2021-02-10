import SwiftUI
import Sleuth

struct Window: View {
    @Binding var session: Session
    @Environment(\.verticalSizeClass) private var vertical
    private let bar = CGFloat(100)
    private let progress = CGFloat(3)
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
                .sheet(item: $session.modal) {
                    switch $0 {
                    case .trackers: Trackers.List(session: $session)
                    case .store: Plus(session: $session)
                    case .froob: Plus.Timemout(session: $session)
                    }
                }
            if session.page == nil {
                History(session: $session)
            } else {
                Web(session: $session)
                    .padding(.init(top: 0, leading: 0,
                                   bottom: session.typing || vertical == .compact ? 0 : bar + progress,
                                   trailing: vertical == .compact && !session.typing ? bar + progress : 0))
                if session.error != nil {
                    Issue(session: $session)
                }
            }
            if !session.typing {
                if vertical == .compact {
                    HStack(spacing: 0) {
                        Spacer()
                        if session.page != nil {
                            GeometryReader { geo in
                                ZStack {
                                    Rectangle()
                                        .fill(Color(white: 0, opacity: 0.2))
                                    VStack {
                                        Rectangle()
                                            .fill(Color.accentColor)
                                            .frame(height: geo.size.height * .init(session.progress))
                                            .animation(.spring(blendDuration: 0.4))
                                        Spacer()
                                    }
                                }
                            }
                            .frame(width: progress)
                        }
                        VStack {
                            Searchbar(session: $session)
                        }
                        .frame(width: bar)
                    }
                } else {
                    VStack(spacing: 0) {
                        Spacer()
                        if session.page != nil {
                            GeometryReader { geo in
                                ZStack {
                                    Rectangle()
                                        .fill(Color(white: 0, opacity: 0.2))
                                    HStack {
                                        Rectangle()
                                            .fill(Color.accentColor)
                                            .frame(width: geo.size.width * .init(session.progress))
                                            .animation(.spring(blendDuration: 0.4))
                                        Spacer()
                                    }
                                }
                            }
                            .frame(height: progress)
                        }
                        HStack {
                            Searchbar(session: $session)
                        }
                        .frame(height: bar)
                    }
                }
            }
            Field(session: $session)
                .frame(width: 0, height: 0)
        }
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
