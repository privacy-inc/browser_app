import SwiftUI

struct Popup<Leading, Content>: View where Leading : View, Content : View {
    let title: String
    let leading: Leading
    let content: Content
    @Environment(\.presentationMode) private var visible
    
    @inlinable public init(title: String, @ViewBuilder leading: () -> Leading, @ViewBuilder content: () -> Content) {
        self.title = title
        self.leading = leading()
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitle(title, displayMode: title.isEmpty ? .inline : .large)
                .navigationBarItems(leading: leading,
                                    trailing:
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
