import SwiftUI
import Sleuth

extension Tab {
    struct Info: View {
        @Binding var session: Session
        let id: UUID
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            Popup(title: "Info", leading: { }) {
                List {
                    Section {
                        Label(secure ? "Secure Connection" : "Site Not Secure",
                              systemImage: secure ? "lock.fill" : "exclamationmark.triangle.fill")
                            .font(.footnote)
                            .accentColor(secure ? .accentColor : .pink)
                        Text(secure ? "Using an encrypted connection to \(domain)" : "Connection to \(domain) is NOT encrypted")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    Section(
                        footer: Button {
                            visible.wrappedValue.dismiss()
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
            }
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
            page.secure ?? false
        }
        
        private var page: Page? {
            session
                .tab[state: id]
                .browse
                .map(session.archive.page)
        }
    }
}
