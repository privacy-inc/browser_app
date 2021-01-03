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
                                .foregroundColor(.white)
                        }
                        Text(verbatim: page.subtitle)
                            .lineLimit(3)
                            .font(.caption2)
                            .foregroundColor(Color(white: 1, opacity: 0.5))
                    }
                    Spacer()
                }
            }
        }
    }
}
