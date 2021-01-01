import SwiftUI
import Sleuth

struct Trackers: View {
    @State private var formatter = NumberFormatter()
    @State private var list = false
    @State private var blocked = [String]()
    
    var body: some View {
        HStack {
            Spacer()
            Text("Trackers blocked")
                .font(.footnote)
                .foregroundColor(blocked.isEmpty ? .secondary : .primary)
            if !blocked.isEmpty {
                Text(NSNumber(value: blocked.count), formatter: formatter)
                    .font(Font.title2.bold().monospacedDigit())
                    .padding(.leading)
            }
            Control.Circle(background: .init(.systemBackground), state: blocked.isEmpty ? .disabled : .ready, image: "shield.lefthalf.fill") {
                guard !blocked.isEmpty else { return }
                list = true
            }
            .sheet(isPresented: $list) {
                List()
            }
        }
        .padding(.horizontal)
        .onAppear {
            formatter.numberStyle = .decimal
            blocked = Shared.blocked
        }
    }
}
