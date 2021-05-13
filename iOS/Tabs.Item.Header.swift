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
                            .foregroundColor(.secondary)
                            .frame(width: 50, height: 50)
                            .contentShape(Rectangle())
                    }
                    Text(verbatim: subtitle)
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Text(verbatim: title)
                    .font(.callout)
                    .lineLimit(1)
                Spacer()
            }
            .frame(height: 80)
        }
        
        private var title: String {
            switch session.tab.state(id) {
            case .new:
                return ""
            case let .history(history):
                return session.archive.page(history).title
            case let .error(_, error):
                return error.description
            }
        }
        
        private var subtitle: String {
            switch session.tab.state(id) {
            case .new:
                return ""
            case let .history(history):
                return session.archive.page(history).domain
            case let .error(_, error):
                return error.domain
            }
        }
    }
}
