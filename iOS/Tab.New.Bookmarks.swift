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
                            tabber.browse(id, $0)
                        }
                } label: {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(.tertiarySystemBackground))
                            Text(verbatim: list[index].access.domain)
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .padding(10)
                        }
                        .fixedSize()
                        Text(verbatim: list[index].title)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.trailing)
                    }
                    .padding(.horizontal)
                    .contentShape(Rectangle())
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .padding(.top, 8)
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
