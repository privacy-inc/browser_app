import SwiftUI

extension Trackers {
    struct Item: View {
        @Binding var session: Session
        let name: String
        let blocks: [Date]
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(verbatim: name)
                        .font(.callout)
                    blocks
                        .last
                        .map {
                            Text(verbatim: RelativeDateTimeFormatter().string(from: $0))
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding(.top, 3)
                        }
                }
                Spacer()
                Text(NSNumber(value: blocks.count), formatter: session.decimal)
                    .font(.title3.monospacedDigit())
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 5)
        }
    }
}
