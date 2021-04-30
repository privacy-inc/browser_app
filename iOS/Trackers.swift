import SwiftUI
import Sleuth

struct Trackers: View {
    @Binding var session: Session
    @State private var formatter = NumberFormatter()
    @State private var blocked = [String]()
    
    var body: some View {
        HStack {
            Spacer()
            Text("Trackers blocked")
                .font(.footnote)
                .foregroundColor(blocked.isEmpty ? .secondary : .primary)
            Text(NSNumber(value: Synch.cloud.archive.value.blocked.count), formatter: formatter)
                .font(Font.title2.bold().monospacedDigit())
                .padding(.leading)
            Control.Circle(background: .init(.systemBackground), image: "shield.lefthalf.fill") {
                UIApplication.shared.resign()
                session.dismiss.send()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    session.modal = .trackers
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            formatter.numberStyle = .decimal
        }
    }
}
