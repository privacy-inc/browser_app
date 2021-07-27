import SwiftUI

extension Tabs.Item {
    struct Footer: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            HStack(alignment: .top) {
                Icon(domain: short)
                Text(verbatim: title)
                    .foregroundColor(.primary)
                + Text(verbatim: " - " + short)
                    .foregroundColor(.secondary)
            }
            .lineLimit(2)
            .font(.footnote)
            .padding(.top, 5)
            .padding(.horizontal)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        }
        
        private var title: String {
            session
                .items[state: id]
                .browse
                .map(session.archive.page)
                .map(\.title)
            ?? ""
        }
        
        private var short: String {
            session
                .items[state: id]
                .browse
                .map(session.archive.page)
                .map(\.access.short)
            ?? ""
        }
    }
}
