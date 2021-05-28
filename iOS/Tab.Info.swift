import SwiftUI
import Sleuth

extension Tab {
    struct Info: View {
        @Binding var session: Session
        let id: UUID
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            NavigationView {
                List {
                    Section(
                        header: Image(systemName: secure ? "lock.fill" : "exclamationmark.triangle.fill")
                                    .font(.title3)) {
                            Text(secure ? "Secure Connection" : "Site Not Secure")
                                .font(.footnote)
                            Text(secure ? "Using an encrypted connection to \(domain)" : "Connection to \(domain) is NOT encrypted")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    Section(
                        footer: Button {
                                    dismiss()
                                    session.toast = .init(title: "URL copied", icon: "doc.on.doc.fill")
                                    UIPasteboard.general.string = url
                                } label: {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "doc.on.doc.fill")
                                            .foregroundColor(.primary)
                                            .frame(width: 30, height: 30)
                                            .padding(.leading, 50)
                                            .padding(.bottom, 10)
                                    }
                                }) {
                            Text(verbatim: title)
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(verbatim: url)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Info", displayMode: .large)
                .navigationBarItems(trailing:
                                        Button(action: dismiss) {
                                            Image(systemName: "xmark")
                                                .foregroundColor(.secondary)
                                                .frame(width: 30, height: 50)
                                                .padding(.leading, 40)
                                                .contentShape(Rectangle())
                                        })
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        
        private var title: String {
            page
                .map(\.title)
            ?? ""
        }
        
        private var url: String {
            page
                .map(\.access.string)
            ?? ""
        }
        
        private var domain: String {
            page
                .map(\.access.domain)
            ?? ""
        }
        
        private var secure: Bool {
            page
                .map {
                    !$0.access.string.hasPrefix(URL.Scheme.http.rawValue + "://")
                }
            ?? true
        }
        
        private var page: Page? {
            session.tabs.state(id).browse
                .map(session.archive.page)
        }
        
        private func dismiss() {
            visible.wrappedValue.dismiss()
        }
    }
}
