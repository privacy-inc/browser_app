import SwiftUI

struct Activity: View {
    @Binding var session: Session
    
    var body: some View {
        Popup(title: "Activity") {
            VStack {
                Chart(values: session.archive.plotter)
                    .frame(height: 180)
                    .padding()
                ZStack {
                    Color(.secondarySystemBackground)
                        .edgesIgnoringSafeArea([.bottom, .leading, .trailing])
                    VStack {
                        Rectangle()
                            .fill(Color(.secondarySystemFill))
                            .frame(height: 1)
                            .edgesIgnoringSafeArea(.horizontal)
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
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                        .padding(.horizontal)
                        Spacer()
                    }
                }
            }
        }
    }
}
