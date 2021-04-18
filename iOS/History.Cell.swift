import SwiftUI
import Sleuth

extension History {
    struct Cell: View {
        let page: Page
        let delete: (Page) -> Void
        let open: () -> Void
        @State private var date = ""
        @State private var background = Color.primary.opacity(0.03)
        
        var body: some View {
            HStack(alignment: .top, spacing: 0) {
                Button(action: open) {
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
                .padding(.vertical)
                .padding(.leading)
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        background = .pink
                    }
                    delete(page)
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .contentShape(Rectangle())
                        .frame(width: 40, height: 40)
                }
            }
            .background(RoundedRectangle(cornerRadius: 12)
                            .fill(background))
            .onAppear {
                date = RelativeDateTimeFormatter().string(from: page.date, to: .init())
            }
        }
    }
}
