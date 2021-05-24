import SwiftUI

extension Tabs.Item {
    struct Footer: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            VStack(alignment: .leading) {
                if !title.isEmpty {
                    Text(verbatim: title)
                        .font(.footnote)
                        .lineLimit(1)
                        .padding(.horizontal)
                }
                Text(verbatim: subtitle)
                    .font(.caption2)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                Spacer()
            }
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        }
        
        private var title: String {
            session
                .tab
                .state(id)
                .browse
                .map(session.archive.page)
                .map(\.title)
            ?? ""
        }
        
        private var subtitle: String {
            session
                .tab
                .state(id)
                .browse
                .map(session.archive.page)
                .map(\.access.domain)
            ?? ""
        }
    }
}
