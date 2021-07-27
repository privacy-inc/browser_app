import SwiftUI

struct Activity: View {
    @Binding var session: Session
    
    var body: some View {
        VStack {
            Text("Activity")
                .font(.footnote)
                .padding([.leading, .top])
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            Chart(values: session.archive.activity.plotter)
                .padding()
            HStack {
                session
                    .archive
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
