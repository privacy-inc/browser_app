import SwiftUI

extension Trackers {
    struct Attempts: View {
        let name: String
        let count: Int
        
        var body: some View {
            Text(NSNumber(value: count), formatter: NumberFormatter.decimal)
                .foregroundColor(.primary)
                .font(.title3.monospacedDigit())
            + Text(verbatim: "\n" + name)
                .foregroundColor(.secondary)
                .font(.callout)
        }
    }
}
