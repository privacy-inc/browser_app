import SwiftUI
import Sleuth

extension History {
    struct Cell: View {
        let page: Share.Page
        
        var body: some View {
            Link(destination: page.url) {
                HStack {
                    VStack(alignment: .leading) {
                        if !page.title.isEmpty {
                            Text(verbatim: page.title)
                                .lineLimit(3)
                                .font(.footnote)
                        }
                        Text(verbatim: page.subtitle)
                            .lineLimit(3)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    Spacer()
                }
                .background(RoundedRectangle(cornerRadius: 18)
                                .fill(Color("AccentColor")
                                        .opacity(0.2)))
            }
        }
    }
}
