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
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.accentColor)
                            Text(verbatim: list[index].access.domain)
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 8)
                        }
                        .fixedSize()
                        Text(verbatim: list[index].title)
                            .font(.footnote)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.trailing)
                    }
                    .padding(.horizontal)
                    .contentShape(Rectangle())
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .padding(.top, 12)
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
