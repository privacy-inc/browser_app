import SwiftUI

struct Trackers: View {
    @Binding var session: Session
    @State private var trackers = [(name: String, count: [Date])]()
    
    var body: some View {
        Popup(title: "Trackers", leading: {
            Image(systemName: "shield.lefthalf.fill")
                .font(.title2)
                .foregroundColor(.init(.tertiaryLabel))
        }) {
            List {
                Section(header:
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(NSNumber(value: trackers.count), formatter: session.decimal)
                                        .font(.largeTitle.monospacedDigit())
                                        .foregroundColor(.primary)
                                    Text("Trackers")
                                        .font(.footnote)
                                }
                                VStack(alignment: .leading) {
                                    Text(NSNumber(value: trackers.map(\.1.count).reduce(0, +)), formatter: session.decimal)
                                        .font(.largeTitle.monospacedDigit())
                                        .foregroundColor(.primary)
                                    Text("Attempts blocked")
                                        .font(.footnote)
                                }
                                .padding(.leading)
                                Spacer()
                            }
                            .textCase(.none)
                            .padding(.vertical, 20)) {
                    ForEach(0 ..< trackers.count, id: \.self) {
                        Item(session: $session, name: trackers[$0].name, count: trackers[$0].count)
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .onAppear {
            trackers = session.archive.trackers
        }
    }
}
