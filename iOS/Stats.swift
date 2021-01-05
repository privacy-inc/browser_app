import SwiftUI
import Sleuth

struct Stats: View {
    @Binding var session: Session
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                Button {
                    visible.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .frame(width: 60, height: 50)
                }
                .contentShape(Rectangle())
                .padding(.top)
            }
            Image(systemName: "chart.bar.xaxis")
                .font(.largeTitle)
                .padding(.bottom)
            Chart(chart: Share.chart)
                .frame(height: 220)
                .padding(.vertical)
            Trackers(session: $session)
                .padding(.vertical)
            HStack {
                Spacer()
                Text("Forget")
                    .font(.footnote)
                Control.Circle(background: .init(.systemBackground), state: .ready, image: "flame") {
                    session.forget.send()
                    visible.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal)
        }
        .onReceive(session.dismiss) {
            visible.wrappedValue.dismiss()
        }
    }
}
