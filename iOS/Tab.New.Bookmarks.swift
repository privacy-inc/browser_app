import SwiftUI
import Sleuth

extension Tab.New {
    struct Bookmarks: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            ForEach(0 ..< list.count, id: \.self) { index in
                Button {
                    cloud
                        .open(index) {
                            session.tab.browse(id, $0)
                        }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.tertiarySystemBackground))
                        HStack {
                            Icon(domain: list[index].access.short)
                            Group {
                                Text(verbatim: list[index].title)
                                    .foregroundColor(.primary)
                                    .font(.footnote)
                                + Text(verbatim: " - " + list[index].access.short)
                                        .foregroundColor(.secondary)
                                        .font(.footnote)
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(3)
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    .contentShape(Rectangle())
                }
            }
        }
        
        private var list: [Page] {
            .init(session
                    .archive
                    .bookmarks
                    .prefix(5))
        }
    }
}
