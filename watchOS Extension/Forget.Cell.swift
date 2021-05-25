import SwiftUI

extension Forget {
    struct Cell: View {
        let title: String
        let action: () -> Void
        @State private var alert = false
        
        var body: some View {
            Button {
                alert = true
            } label: {
                Text(title)
                    .font(.footnote)
                    .frame(maxWidth: .greatestFiniteMagnitude)
            }
            .alert(isPresented: $alert) {
                .init(title: .init(title),
                      primaryButton: .destructive(.init("Continue"), action: action),
                      secondaryButton: .cancel())
            }
        }
    }
}
