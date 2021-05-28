import SwiftUI
import WebKit
import Sleuth

extension Tab {
    struct Error: View {
        @Binding var session: Session
        let id: UUID
        let browse: Int
        let error: Sleuth.Tab.Error
        
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
                    Text(verbatim: error.domain)
                        .padding(.horizontal)
                        .frame(maxWidth: 300, alignment: .leading)
                    Text(verbatim: error.description)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.horizontal, .bottom])
                        .frame(maxWidth: 300, alignment: .leading)
                    Control(title: "Try again", image: "gobackward") {
                        cloud
                            .browse(error.url, id: browse) {
                                tabber.browse(id, $0)
                                session.load.send((id: id, access: $1))
                            }
                    }
                    Control(title: "Cancel", image: "xmark") {
                        guard let web = session.tabs[web: id] as? WKWebView else { return }
                        if web.url == nil {
                            tabber.clear(id)
                        } else {
                            cloud.update(browse, url: web.url ?? URL(string: "about:blank")!)
                            cloud.update(browse, title: web.title ?? "")
                            tabber.dismiss(id)
                        }
                    }
                    Spacer()
                        .frame(height: 30)
                }
            }
        }
    }
}
