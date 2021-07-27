import SwiftUI

extension Info {
    struct Message<Content>: View where Content : View {
        let title: String
        let message: String
        let button: Content
        
        @inlinable public init(title: String, message: String, @ViewBuilder button: () -> Content) {
            self.title = title
            self.message = message
            self.button = button()
        }
        
        var body: some View {
            VStack {
                Group {
                    Text(title)
                        .font(Font.title.bold())
                    + Text(message)
                        .foregroundColor(.secondary)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Spacer()
                button
            }
            .padding()
        }
    }

}
