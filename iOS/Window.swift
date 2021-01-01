import SwiftUI
import Sleuth

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
//                VStack {
                    
//                    Spacer()
//                }
//                if session.state.error != nil {
//                    VStack {
//                        Image(systemName: "exclamationmark.triangle.fill")
//                            .font(Font.largeTitle.bold())
//                            .foregroundColor(.accentColor)
//                        Text(verbatim: session.page?.url.absoluteString ?? "")
//                            .multilineTextAlignment(.center)
//                            .font(.footnote)
//                            .foregroundColor(.secondary)
//                            .padding()
//                        Text(verbatim: session.state.error!)
//                            .padding(.horizontal)
//                            .multilineTextAlignment(.center)
//                    }
//                }
                if session.page == nil {
                    History(session: $session)
                } else {
                    Web(session: $session)
                }
                if !session.typing {
                    Progress(session: $session)
                }
                Searchbar(session: $session)
            }
            .animation(.easeInOut(duration: 0.35))
        }
        .onReceive(session.browse) {
            guard session.page == nil else { return }
            session.page = .init(url: $0)
        }
        .onReceive(session.forget) {
            FileManager.forget()
            UIApplication.shared.forget()
            Shared.history = []
            Shared.chart = []
            Shared.blocked = []
        }
    }
}
