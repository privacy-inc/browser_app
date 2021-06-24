import SwiftUI
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
                            .browse(error.url, browse: browse) {
                                tabber.browse(id, $0)
                                session.load.send((id: id, access: $1))
                            }
                    }
                    .frame(maxWidth: 200)
                    Control(title: "Cancel", image: "xmark") {
                        guard let web = session.tab[web: id] as? Web.Coordinator else { return }
                        if let url = web.url {
                            cloud.update(browse, url: url)
                            cloud.update(browse, title: web.title ?? "")
                            tabber.dismiss(id)
                        } else {
                            withAnimation(.spring(blendDuration: 0.4)) {
                                session.section = .tab(tabber.new())
                            }
                            web.clear()
                            tabber.close(id)
                        }
                    }
                    .frame(width: 200)
                    Spacer()
                        .frame(height: 30)
                }
            }
        }
    }
}
