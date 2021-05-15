import SwiftUI

extension Tabs.Item {
    struct Header: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        withAnimation(.spring(blendDuration: 0.6)) {
                            session.tab.close(id)
                            session.remove(id)
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .frame(width: 46, height: 36)
                            .contentShape(Rectangle())
                    }
                    Text(verbatim: subtitle)
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .offset(x: -10)
                    Spacer()
                }
                Text(verbatim: title)
                    .font(.footnote)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                Spacer()
            }
            .frame(height: 65)
        }
        
        private var title: String {
            switch session.tab.state(id) {
            case .new:
                return ""
            case let .browse(browse):
                return session.archive.page(browse).title
            case let .error(_, error):
                return error.description
            }
        }
        
        private var subtitle: String {
            switch session.tab.state(id) {
            case .new:
                return ""
            case let .browse(browse):
                return session.archive.page(browse).domain
            case let .error(_, error):
                return error.domain
            }
        }
    }
}
