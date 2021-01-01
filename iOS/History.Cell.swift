import SwiftUI
import Sleuth

extension History {
    struct Cell: View {
        let page: Page
        let delete: () -> Void
        let action: () -> Void
        @State private var date = ""
        
        var body: some View {
            HStack(spacing: 0) {
                Button(action: action) {
                    VStack(alignment: .leading) {
                        Text(verbatim: date)
                            .font(.caption2)
                            .foregroundColor(.init(.secondary))
                        if !page.title.isEmpty {
                            Text(verbatim: page.title)
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.primary)
                        }
                        Text(verbatim: page.url.absoluteString)
                            .font(.caption2)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(3)
                            .foregroundColor(.init(.tertiaryLabel))
                    }
                }
                Spacer()
                Button(action: delete) {
                    Image(systemName: "xmark")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.trailing)
                }
                .frame(width: 40)
                .contentShape(Rectangle())
            }
            .padding(.vertical)
            .padding(.leading)
            .background(RoundedRectangle(cornerRadius: 14)
                            .fill(Color.primary.opacity(0.03)))
            .onAppear {
                date = RelativeDateTimeFormatter().localizedString(for: page.date, relativeTo: .init())
            }
        }
    }
}
