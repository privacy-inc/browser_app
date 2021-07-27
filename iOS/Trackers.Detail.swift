import SwiftUI

extension Trackers {
    struct Detail: View {
        let title: String
        let dates: [Date]
        
        var body: some View {
            VStack(spacing: 0) {
                Activity.Chart(values: dates.plotter)
                    .frame(height: 300)
                    .padding()
                HStack {
                    dates
                        .first
                        .map {
                            Text(verbatim: RelativeDateTimeFormatter().string(from: $0))
                        }
                    Rectangle()
                        .frame(height: 1)
                    Text("Now")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                Spacer()
            }
            .padding()
            .navigationBarTitle(title, displayMode: .inline)
        }
    }
}
