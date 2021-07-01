import SwiftUI

extension Trackers {
    struct Detail: View {
        let title: String
        let dates: [Date]
        
        var body: some View {
            VStack(spacing: 0) {
                Chart(values: dates.plotter)
                    .frame(height: 150)
                    .padding(.horizontal, 40)
                    .padding(.top, 50)
                    .padding(.bottom, 30)
                HStack {
                    dates
                        .first
                        .map {
                            Text(verbatim: RelativeDateTimeFormatter().string(from: $0))
                        }
                    Spacer()
                    Text("Now")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
                Spacer()
            }
            .navigationBarTitle(title, displayMode: .inline)
        }
    }
}
