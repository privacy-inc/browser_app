import SwiftUI

struct Trackers: View {
    @Binding var session: Session
    @State private var formatter = NumberFormatter()
    @State private var list = false
    
    var body: some View {
        HStack {
            Spacer()
            Text("Trackers blocked")
                .font(.footnote)
                .foregroundColor(session.blocked.isEmpty ? .secondary : .primary)
            if !session.blocked.isEmpty {
                Text(NSNumber(value: session.blocked.count), formatter: formatter)
                    .font(Font.title2.bold().monospacedDigit())
                    .padding(.leading)
            }
            Control.Circle(background: .init(.systemBackground), state: session.blocked.isEmpty ? .disabled : .ready, image: "shield.lefthalf.fill") {
                guard !session.blocked.isEmpty else { return }
                list = true
            }
            .sheet(isPresented: $list) {
                List(session: $session)
            }
        }
        .padding(.horizontal)
        .onAppear {
            formatter.numberStyle = .decimal
        }
    }
}
