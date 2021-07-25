import SwiftUI

extension Tabs.Item {
    struct Footer: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            VStack(alignment: .leading) {
                if !title.isEmpty {
                    Text(verbatim: title)
                }
                Text(verbatim: subtitle)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .lineLimit(1)
            .font(.footnote)
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
        
        private var subtitle: String {
            session
                .items[state: id]
                .browse
                .map(session.archive.page)
                .map(\.access.short)
            ?? ""
        }
    }
}
