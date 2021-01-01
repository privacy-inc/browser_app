import SwiftUI

struct Detail: View {
    @Binding var session: Session
//    @AppStorage(Defaults.Key.settings_sound.rawValue) private var sound = true
//    @AppStorage(Defaults.Key.settings_vibrate.rawValue) private var vibrate = true
    @State private var formatter = NumberFormatter()
    @State private var trackers = false
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
            HStack {
                VStack(alignment: .leading) {
                    Text(verbatim: session.page!.title)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(Font.title2.bold())
                        .foregroundColor(.primary)
                    Text(verbatim: session.page!.url.absoluteString)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Spacer()
            }
            .padding(.horizontal)
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
                    trackers = true
                }
                .sheet(isPresented: $trackers) {
                    Trackers(session: $session)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            formatter.numberStyle = .decimal
        }
    }
}
