import SwiftUI

extension Trackers {
    struct Recent: View {
        let name: String
        let last: Date
        
        var body: some View {
            Text(verbatim: RelativeDateTimeFormatter().string(from: last))
                .font(.body)
                .foregroundColor(.primary)
            + Text(verbatim: "\n" + name)
                .foregroundColor(.secondary)
                .font(.callout)
        }
    }
}
