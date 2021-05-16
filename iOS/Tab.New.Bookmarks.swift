import SwiftUI
import Sleuth

extension Tab.New {
    struct Bookmarks: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            ForEach(0 ..< list.count, id: \.self) { page in
                if page != 0 {
                    Rectangle()
                        .fill(Color(.secondarySystemFill))
                        .frame(height: 1)
                        .padding(.horizontal)
                }
                Button {
                    
                } label: {
                    VStack(alignment: .leading) {
                        Text(list[page].title)
                            .font(.footnote)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(list[page].domain)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .contentShape(Rectangle())
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
            }
        }
        
        private var list: [Page] {
            .init(session
                    .archive
                    .bookmarks
                    .prefix(3))
        }
    }
}
