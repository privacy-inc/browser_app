import SwiftUI

struct Popup<Content>: View where Content : View {
    let title: String
    let content: Content
    @Environment(\.presentationMode) private var visible
    
    @inlinable public init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .listStyle(GroupedListStyle())
                .navigationBarTitle(title, displayMode: .large)
                .navigationBarItems(trailing:
                                        Button {
                                            visible.wrappedValue.dismiss()
                                        } label: {
                                            Image(systemName: "xmark")
                                                .foregroundColor(.secondary)
                                                .frame(width: 30, height: 50)
                                                .padding(.leading, 40)
                                                .contentShape(Rectangle())
                                        })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
