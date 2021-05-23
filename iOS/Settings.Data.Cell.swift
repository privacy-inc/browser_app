import SwiftUI

extension Settings.Data {
    struct Cell: View {
        let title: String
        let action: () -> Void
        @State private var alert = false
        
        var body: some View {
            Button {
                alert = true
            } label: {
                Text(title)
                    .font(.callout)
                    .frame(maxWidth: .greatestFiniteMagnitude)
            }
            .actionSheet(isPresented: $alert) {
                .init(title: .init(title),
                      buttons: [
                        .destructive(.init("Continue"), action: action),
                        .cancel()])
            }
        }
    }
}
