import SwiftUI
import WebKit
import Archivable
import Sleuth

extension Tab {
    struct Error: View {
        @Binding var session: Session
        let id: UUID
        let browse: Int
        let error: WebError
        
        var body: some View {
            ZStack {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea(.horizontal)
                ScrollView {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .padding()
                        .padding(.top)
                        .frame(maxWidth: 300, alignment: .leading)
                    Text(error.domain)
                        .padding(.horizontal)
                        .frame(maxWidth: 300, alignment: .leading)
                    Text(error.description)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.horizontal, .bottom])
                        .frame(maxWidth: 300, alignment: .leading)
                    Control(title: "Try again", image: "gobackward") {
                        Cloud.shared.browse(error.url, id: browse) {
                            session.tab.browse(id, $0)
                            session.load.send((id: id, access: $1))
                        }
                    }
                    Control(title: "Cancel", image: "xmark") {
                        guard let web = session.tab[web: id] as? WKWebView else { return }
                        if web.url == nil {
                            session.tab.clear(id)
                        } else {
                            Cloud.shared.update(browse, url: web.url ?? URL(string: "about:blank")!)
                            Cloud.shared.update(browse, title: web.title ?? "")
                            session.tab.dismiss(id)
                        }
                    }
                    Spacer()
                        .frame(height: 30)
                }
            }
        }
    }
}
