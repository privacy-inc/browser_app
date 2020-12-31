import SwiftUI
import Sleuth

extension History {
    struct Cell: View {
        let page: Page
        let delete: () -> Void
        let action: () -> Void
        @State private var date = ""
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.primary.opacity(0.03))
                    VStack {
                        HStack {
                            Spacer()
                            Text(verbatim: date)
                                .font(.caption2)
                                .foregroundColor(.init(.secondary))
                        }
                        if !page.title.isEmpty {
                            HStack {
                                Text(verbatim: page.title)
                                    .font(.footnote)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                        }
                        HStack {
                            Text(verbatim: page.url.absoluteString)
                                .font(.caption2)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(3)
                                .foregroundColor(.init(.tertiaryLabel))
                            Spacer()
                            
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                date = RelativeDateTimeFormatter().localizedString(for: page.date, relativeTo: .init())
            }
        }
    }
}
