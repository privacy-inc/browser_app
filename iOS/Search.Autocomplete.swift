import SwiftUI
import Sleuth

extension Search {
    struct Autocomplete: View {
        @Binding var session: Session
        let id: UUID
        let title: String
        let items: [Filtered]
        private let width = CGFloat(125)
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .frame(minHeight: width)
                HStack {
                    Text(title)
                        .font(.footnote.bold())
                        .foregroundColor(.init(.tertiaryLabel))
                        .frame(width: width)
                        .rotationEffect(.radians(.pi / -2), anchor: .leading)
                        .padding(.leading, 20)
                        .offset(y: width / 2)
                    Spacer()
                }
                VStack(spacing: 18) {
                    ForEach(items, id: \.self) { item in
                        Cell(item: item) {
                            let browse = session.tab[state: id].browse
                            cloud
                                .browse(item.url, browse: browse) {
                                    UIApplication.shared.resign()
                                    session.section = .tab(id)
                                    tabber.browse(id, $0)
                                    if browse == $0 {
                                        session.load.send((id: id, access: $1))
                                    }
                                }
                        }
                    }
                }
                .padding(.vertical, 22)
                .padding(.leading, 30)
            }
            .padding(.horizontal)
        }
    }
}
