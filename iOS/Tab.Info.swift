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
                    switch page?.access {
                    case let .remote(remote):
                        Section {
                            Label(remote.secure ? "Secure Connection" : "Site Not Secure",
                                  systemImage: remote.secure ? "lock.fill" : "exclamationmark.triangle.fill")
                                .font(.footnote)
                                .accentColor(remote.secure ? .accentColor : .pink)
                            Text(remote.secure ? "Using an encrypted connection to \(short)" : "Connection to \(short) is NOT encrypted")
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
                    case let .local(local):
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
                            Text(verbatim: local.path)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    default:
                        EmptyView()
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
                .map(\.access.value)
                ?? ""
        }
        
        private var short: String {
            page
                .map(\.access.short)
                ?? ""
        }
        
        private var page: Page? {
            session
                .items[state: id]
                .browse
                .map(session.archive.page)
        }
    }
}
