import SwiftUI

struct Trackers: View {
    @Binding var session: Session
    @State private var trackers = [(name: String, count: [Date])]()
    
    var body: some View {
        List {
            Section(header:
                        VStack {
                            Image(systemName: "shield.lefthalf.fill")
                                .font(.title)
                                .foregroundColor(.accentColor)
                                .padding(.vertical)
                            Text(NSNumber(value: trackers.count), formatter: session.decimal)
                                .font(.title.monospacedDigit())
                                .foregroundColor(.pink)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                            Text("Trackers")
                                .font(.footnote)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                .padding(.bottom)
                            Text(NSNumber(value: trackers.map(\.1.count).reduce(0, +)), formatter: session.decimal)
                                .font(.title.monospacedDigit())
                                .foregroundColor(.pink)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                .padding(.top)
                            Text("Attempts blocked")
                                .font(.footnote)
                                .padding(.bottom)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        }
                        .textCase(.none)
                        .padding()) {
                ForEach(0 ..< trackers.count, id: \.self) {
                    Item(session: $session, name: trackers[$0].name, count: trackers[$0].count)
                }
            }
        }
        .onAppear {
            trackers = session.archive.trackers
        }
        .onChange(of: session.archive) {
            trackers = $0.trackers
        }
    }
}
