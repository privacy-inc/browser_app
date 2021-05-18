import SwiftUI

extension Tab {
    struct Info: View, Tabber {
        @Binding var session: Session
        let id: UUID
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            NavigationView {
                List {
                    Section(
                        header: Text("Title")) {
                            Text(verbatim: title)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    Section(
                        header: Text("URL"),
                        footer: Button {
                                    dismiss()
                                    session.toast = .init(title: "URL copied", icon: "doc.on.doc.fill")
                                    UIPasteboard.general.string = url
                                } label: {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "doc.on.doc.fill")
                                            .font(.title3)
                                            .foregroundColor(.primary)
                                            .frame(width: 30, height: 50)
                                            .padding(.leading, 50)
                                    }
                                }) {
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
            browse
                .map(session.archive.page)
                .map(\.title)
            ?? ""
        }
        
        private var url: String {
            browse
                .map(session.archive.page)
                .map(\.string)
            ?? ""
        }
        
        private func dismiss() {
            visible.wrappedValue.dismiss()
        }
    }
}
