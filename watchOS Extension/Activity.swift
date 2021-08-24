import SwiftUI
import Sleuth

struct Activity: View {
    let archive: Archive
    
    var body: some View {
        VStack {
            Text("Activity")
                .font(.footnote)
                .padding([.leading, .top])
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            Chart(values: archive.activity.plotter)
                .padding()
            HStack {
                archive
                    .activity
                    .first
                    .map {
                        Text(verbatim: RelativeDateTimeFormatter().string(from: $0))
                    }
                Rectangle()
                    .frame(height: 1)
                Text("Now")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            .padding(.horizontal)
        }
        .edgesIgnoringSafeArea(.top)
    }
}
