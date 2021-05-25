import SwiftUI

struct Activity: View {
    @Binding var session: Session
    
    var body: some View {
        VStack {
            Text("Activity")
                .font(.footnote)
                .padding([.leading, .top])
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0, green: 0.2, blue: 0.3, opacity: 1))
                Chart(values: session.archive.plotter, background: .init(red: 0, green: 0.2, blue: 0.3, opacity: 1))
                    .padding()
                    .padding()
            }
            .padding()
            HStack {
                session
                    .archive
                    .since
                    .map {
                        Text(verbatim: RelativeDateTimeFormatter().string(from: $0))
                    }
                Spacer()
                Text("Now")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            .padding(.horizontal)
        }
        .edgesIgnoringSafeArea(.top)
    }
}
