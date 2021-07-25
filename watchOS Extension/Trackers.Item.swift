import SwiftUI

extension Trackers {
    struct Item: View {
        @Binding var session: Session
        let name: String
        let count: [Date]
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(verbatim: name)
                        .font(.caption2)
                    count
                        .last
                        .map {
                            Text(verbatim: RelativeDateTimeFormatter().string(from: $0))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                }
                Spacer()
                Text(NSNumber(value: count.count), formatter: NumberFormatter.decimal)
                    .font(.caption2.monospacedDigit())
                    .foregroundColor(.secondary)
            }
        }
    }
}
