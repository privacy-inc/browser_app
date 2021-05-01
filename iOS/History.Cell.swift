import SwiftUI
import Sleuth

extension History {
    struct Cell: View {
        let entry: Entry
        let delete: (Int) -> Void
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
                        if !entry.title.isEmpty {
                            Text(verbatim: entry.title)
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.primary)
                        }
                        Text(verbatim: entry.url)
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
                    delete(entry.id)
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
                date = RelativeDateTimeFormatter().string(from: entry.date, to: .init())
            }
        }
    }
}
