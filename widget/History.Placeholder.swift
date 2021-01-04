import SwiftUI

extension History {
    struct Placeholder: View {
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(verbatim: "Lorem ipsum dolor")
                        .lineLimit(2)
                        .font(.footnote)
                    Text(verbatim: "sit amet, consectetur adipiscing elit.")
                        .lineLimit(2)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .redacted(reason: .placeholder)
        }
    }
}
