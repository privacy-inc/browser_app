import SwiftUI
import Archivable
import Sleuth

extension Collection {
    struct History: View {
        @Binding var session: Session
        let browse: [Browse]
        let dismiss: () -> Void
        
        var body: some View {
            ForEach(0 ..< browse.count, id: \.self) { index in
                Button {
                    Cloud.shared.revisit(browse[index].id)
                    
                    switch session.section {
                    case let .tab(id):
                        session.tab.browse(id, browse[index].id)
                    default:
                        break
                    }
                    
                    dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        Text(RelativeDateTimeFormatter().string(from: browse[index].date))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        if !browse[index].page.title.isEmpty {
                            Text(browse[index].page.title)
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Text(browse[index].page.domain)
                            .font(.caption2)
                            .foregroundColor(.init(.tertiaryLabel))
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(.vertical, 3)
                }
            }
        }
    }
}
