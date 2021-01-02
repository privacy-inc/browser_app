import SwiftUI
import Sleuth

extension History {
    struct Cell: View {
        let page: Share.Page
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    if !page.title.isEmpty {
                        Text(verbatim: page.title)
                            .lineLimit(2)
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                    Text(verbatim: page.subtitle)
                        .lineLimit(2)
                        .font(.caption2)
                        .foregroundColor(Color(white: 1, opacity: 0.5))
                }
                Spacer()
            }
        }
    }
}
