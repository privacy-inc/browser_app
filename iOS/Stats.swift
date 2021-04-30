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
            Chart(chart: Synch.cloud.archive.value.activity)
                .frame(height: 220)
                .padding(.bottom)
            Trackers(session: $session)
                .padding(.vertical)
            HStack {
                Spacer()
                Text("Forget")
                    .font(.footnote)
                Control.Circle(background: .init(.systemBackground), image: "flame.fill") {
                    Synch.cloud.forget()
                    visible.wrappedValue.dismiss()
                }
            }
            .padding(.trailing)
            HStack {
                Spacer()
                Text("Privacy Plus")
                    .font(.footnote)
                Control.Circle(background: .init(.systemBackground), image: "plus") {
                    session.purchases.open.send()
                }
            }
            .padding([.trailing, .top])
            Spacer()
                .frame(height: 40)
        }
        .onReceive(session.dismiss) {
            visible.wrappedValue.dismiss()
        }
    }
}
