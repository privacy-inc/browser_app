import SwiftUI
import Sleuth

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
                .sheet(item: $session.modal) {
                    switch $0 {
                    case .trackers: Trackers.List(session: $session)
                    case .store: Settings(session: $session)
                    }
                }
            VStack(spacing: 0) {
                if session.page == nil {
                    History(session: $session)
                } else {
                    ZStack {
                        Web(session: $session)
                        if session.error != nil {
                            Color.background
                                .edgesIgnoringSafeArea(.all)
                            VStack {
                                Spacer()
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(Font.largeTitle.bold())
                                    .foregroundColor(.accentColor)
                                    .padding(.bottom)
                                if session.page != nil {
                                    Text(verbatim: session.page!.url.absoluteString)
                                        .multilineTextAlignment(.center)
                                        .padding(.top)
                                        .padding(.horizontal)
                                        .padding(.bottom)
                                }
                                Text(verbatim: session.error!)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                                    .frame(maxWidth: 280)
                                Spacer()
                            }
                        }
                    }
                }
                if !session.typing {
                    Progress(session: $session)
                }
                Searchbar(session: $session)
            }
            .animation(.easeInOut(duration: 0.3))
        }
    }
}
