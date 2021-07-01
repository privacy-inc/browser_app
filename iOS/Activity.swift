import SwiftUI

struct Activity: View {
    @Binding var session: Session
    
    var body: some View {
        Popup(title: "Activity", leading: { }) {
            VStack(spacing: 0) {
                Chart(values: session.archive.activity.plotter)
                    .frame(height: 220)
                    .padding()
                HStack {
                    session
                        .archive
                        .activity
                        .first
                        .map {
                            Text(verbatim: RelativeDateTimeFormatter().string(from: $0))
                        }
                    Spacer()
                    Text("Now")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                Spacer()
            }
        }
    }
}
