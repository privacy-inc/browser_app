import SwiftUI

struct Trackers: View {
    @Binding var session: Session
    let trackers: [(name: String, count: [Date])]
    
    var body: some View {
        Popup(title: "Trackers blocked", leading: { }) {
            List {
                Section(header:
                            HStack {
                                Image(systemName: "shield.lefthalf.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.accentColor)
                                VStack {
                                    Text(NSNumber(value: trackers.count), formatter: session.decimal)
                                        .font(.title.monospacedDigit())
                                        .foregroundColor(.pink)
                                    Text("Trackers")
                                        .font(.caption)
                                }
                                VStack {
                                    Text(NSNumber(value: trackers.map(\.1.count).reduce(0, +)), formatter: session.decimal)
                                        .font(.title.monospacedDigit())
                                        .foregroundColor(.pink)
                                    Text("Incidences")
                                        .font(.caption)
                                }
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
    }
}
