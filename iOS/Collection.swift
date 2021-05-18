import SwiftUI

struct Collection: View {
    @Binding var session: Session
    let modal: Session.Modal
    let id: UUID
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        NavigationView {
            List {
                History(session: $session, id: id, browse: session.archive.browse, dismiss: dismiss)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(title, displayMode: .large)
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
        switch modal {
        case .bookmarks:
            return "Bookmarks"
        case .history:
            return "Recent"
        }
    }
    
    private func dismiss() {
        visible.wrappedValue.dismiss()
    }
}
